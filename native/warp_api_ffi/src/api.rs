use crate::POST_COBJ;
use allo_isolate::IntoDart;
use android_logger::Config;
use log::{error, info, Level};
use once_cell::sync::OnceCell;
use std::fs::File;
use std::io::Read;
use std::sync::{Mutex, MutexGuard};
use sync::{broadcast_tx, ChainError, MemPool, Wallet};
use tokio::runtime::Runtime;
use tokio::time::Duration;
use zcash_multisig::{
    run_aggregator_service, run_signer_service, signer_connect_to_aggregator, submit_tx,
    SecretShare,
};
use zcash_primitives::transaction::builder::Progress;

static RUNTIME: OnceCell<Mutex<Runtime>> = OnceCell::new();
static WALLET: OnceCell<Mutex<Wallet>> = OnceCell::new();
static MEMPOOL: OnceCell<Mutex<MemPool>> = OnceCell::new();
static SYNCLOCK: OnceCell<Mutex<()>> = OnceCell::new();
static MULTISIG_AGG_LOCK: OnceCell<Mutex<MultisigAggregator>> = OnceCell::new();
static MULTISIG_SIGN_LOCK: OnceCell<Mutex<MultisigClient>> = OnceCell::new();

fn get_lock<T>(cell: &OnceCell<Mutex<T>>) -> anyhow::Result<MutexGuard<T>> {
    cell.get()
        .unwrap()
        .lock()
        .map_err(|_| anyhow::anyhow!("Could not acquire lock"))
}

fn get_runtime() -> Runtime {
    Runtime::new().unwrap()
}

fn log_result<T: Default>(result: anyhow::Result<T>) -> T {
    match result {
        Err(err) => {
            log::error!("{}", err);
            T::default()
        }
        Ok(v) => v,
    }
}

fn log_result_string(result: anyhow::Result<String>) -> String {
    match result {
        Err(err) => {
            log::error!("{}", err);
            format!("{}", err)
        }
        Ok(v) => v,
    }
}

pub fn init_wallet(db_path: &str, ld_url: &str) {
    android_logger::init_once(Config::default().with_min_level(Level::Info));
    info!("Init");
    RUNTIME.get_or_init(|| Mutex::new(Runtime::new().unwrap()));
    WALLET.get_or_init(|| {
        info!("Wallet Init");
        let wallet = Wallet::new(db_path, ld_url);
        Mutex::new(wallet)
    });
    MEMPOOL.get_or_init(|| {
        info!("Mempool Init");
        let mempool = MemPool::new(db_path, ld_url);
        Mutex::new(mempool)
    });
    SYNCLOCK.get_or_init(|| Mutex::new(()));
    MULTISIG_AGG_LOCK.get_or_init(|| Mutex::new(MultisigAggregator::new()));
    MULTISIG_SIGN_LOCK.get_or_init(|| Mutex::new(MultisigClient::new()));
}

pub fn reset_app() {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        wallet.reset_db()
    };
    log_result(res())
}

pub fn new_account(name: &str, data: &str) -> i32 {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        wallet.new_account(name, data)
    };
    log_result(res())
}

async fn warp(
    get_tx: bool,
    anchor_offset: u32,
    db_path: &str,
    ld_url: &str,
    port: i64,
) -> anyhow::Result<()> {
    info!("Sync started");
    Wallet::sync_ex(
        get_tx,
        anchor_offset,
        &db_path,
        move |height| {
            let mut height = height.into_dart();
            if port != 0 {
                unsafe {
                    POST_COBJ.map(|p| {
                        p(port, &mut height);
                    });
                }
            }
        },
        ld_url,
    )
    .await?;
    info!("Sync finished");
    let mut mempool = get_lock(&MEMPOOL)?;
    mempool.scan().await?;
    Ok(())
}

fn convert_sync_result(result: anyhow::Result<()>) -> i8 {
    match result {
        Ok(_) => 0,
        Err(err) => {
            if let Some(e) = err.downcast_ref::<ChainError>() {
                match e {
                    ChainError::Reorg => 1,
                    ChainError::Busy => 2,
                }
            } else {
                error!("{}", err);
                -1
            }
        }
    }
}

pub fn warp_sync(get_tx: bool, anchor_offset: u32, port: i64) -> i8 {
    let r = get_runtime();
    let res = r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let _sync_lock = get_lock(&SYNCLOCK)?;
        let wallet = get_lock(&WALLET)?;
        let db_path = wallet.db_path.clone();
        let ld_url = wallet.ld_url.clone();
        drop(wallet);
        warp(get_tx, anchor_offset, &db_path, &ld_url, port).await?;
        Ok::<_, anyhow::Error>(())
    });
    convert_sync_result(res)
}

pub fn try_warp_sync(get_tx: bool, anchor_offset: u32) -> i8 {
    let r = get_runtime();
    let res = r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let _sync_lock = SYNCLOCK
            .get()
            .ok_or_else(|| anyhow::anyhow!("Lock not initialized"))?
            .try_lock();
        if _sync_lock.is_ok() {
            let wallet = get_lock(&WALLET)?;
            let db_path = wallet.db_path.clone();
            let ld_url = wallet.ld_url.clone();
            drop(wallet);
            warp(get_tx, anchor_offset, &db_path, &ld_url, 0).await?;
            Ok::<_, anyhow::Error>(())
        } else {
            Err(anyhow::anyhow!(ChainError::Busy))
        }
    });
    convert_sync_result(res)
}

pub fn valid_address(address: &str) -> bool {
    Wallet::valid_address(address)
}

pub fn new_address(account: u32) -> String {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        wallet.new_diversified_address(account)
    };
    log_result(res())
}

pub fn get_latest_height() -> u32 {
    let r = get_runtime();
    let res = r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let wallet = get_lock(&WALLET)?;
        let height = sync::latest_height(&wallet.ld_url).await?;
        Ok::<_, anyhow::Error>(height)
    });
    log_result(res)
}

fn report_progress(progress: Progress, port: i64) {
    if port != 0 {
        let progress = match progress.end() {
            Some(end) => (progress.cur() * 100 / end) as i32,
            None => -(progress.cur() as i32),
        };
        let mut progress = progress.into_dart();
        unsafe {
            POST_COBJ.map(|p| {
                p(port, &mut progress);
            });
        }
    }
}

pub fn send_multi_payment(
    account: u32,
    recipients_json: &str,
    use_transparent: bool,
    anchor_offset: u32,
    port: i64,
) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_lock(&WALLET)?;
        let height = sync::latest_height(&wallet.ld_url).await?;
        let recipients = Wallet::parse_recipients(recipients_json)?;
        let res = wallet
            .build_sign_send_multi_payment(
                account,
                height,
                &recipients,
                use_transparent,
                anchor_offset,
                move |progress| {
                    report_progress(progress, port);
                },
            )
            .await?;
        Ok(res)
    });
    log_result_string(res)
}

pub fn skip_to_last_height() {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_lock(&WALLET)?;
        wallet.skip_to_last_height().await
    });
    log_result(res)
}

pub fn rewind_to_height(height: u32) {
    let res = || {
        let mut wallet = get_lock(&WALLET)?;
        wallet.rewind_to_height(height)
    };
    log_result(res())
}

pub fn mempool_sync() -> i64 {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut mempool = get_lock(&MEMPOOL)?;
        mempool.scan().await
    });
    log_result(res)
}

pub fn set_mempool_account(account: u32) {
    let res = || {
        let mut mempool = get_lock(&MEMPOOL)?;
        mempool.set_account(account)
    };
    log_result(res());
}

pub fn mempool_reset(height: u32) {
    let res = || {
        let mut mempool = get_lock(&MEMPOOL)?;
        mempool.clear(height)
    };
    log_result(res());
}

pub fn get_mempool_balance() -> i64 {
    let res = || {
        let mempool = get_lock(&MEMPOOL)?;
        Ok(mempool.get_unconfirmed_balance())
    };
    log_result(res())
}

pub fn get_taddr_balance(account: u32) -> u64 {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_lock(&WALLET)?;
        wallet.get_taddr_balance(account).await
    });
    log_result(res)
}

pub fn shield_taddr(account: u32) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_lock(&WALLET)?;
        let height = sync::latest_height(&wallet.ld_url).await?;
        wallet.shield_taddr(account, height).await
    });
    log_result(res)
}

pub fn set_lwd_url(url: &str) {
    let res = || {
        let mut wallet = get_lock(&WALLET)?;
        wallet.set_lwd_url(url)
    };
    log_result(res())
}

pub fn prepare_multi_payment(
    account: u32,
    recipients_json: &str,
    use_transparent: bool,
    anchor_offset: u32,
) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_lock(&WALLET)?;
        let last_height = sync::latest_height(&wallet.ld_url).await?;
        let recipients = Wallet::parse_recipients(recipients_json)?;
        let tx = wallet
            .build_only_multi_payment(
                account,
                last_height,
                &recipients,
                use_transparent,
                anchor_offset,
            )
            .await?;
        Ok(tx)
    });
    log_result_string(res)
}

pub fn broadcast(tx_filename: &str) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_lock(&WALLET)?;
        let mut file = File::open(&tx_filename)?;
        let mut s = String::new();
        file.read_to_string(&mut s)?;
        let tx = hex::decode(s.trim_end())?;
        broadcast_tx(&tx, &wallet.ld_url).await
    });
    log_result_string(res)
}

pub fn broadcast_txhex(txhex: &str) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_lock(&WALLET)?;
        let tx = hex::decode(txhex)?;
        broadcast_tx(&tx, &wallet.ld_url).await
    });
    log_result_string(res)
}

pub fn sync_historical_prices(now: i64, days: u32, currency: &str) -> u32 {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_lock(&WALLET)?;
        wallet.sync_historical_prices(now, days, currency).await
    });
    log_result(res)
}

pub fn get_ua(sapling_addr: &str, transparent_addr: &str) -> String {
    let res = || {
        let ua = sync::get_ua(sapling_addr, transparent_addr)?;
        Ok(ua.to_string())
    };
    log_result(res())
}

pub fn get_sapling(ua_addr: &str) -> String {
    let z_addr = sync::get_sapling(ua_addr);
    match z_addr {
        Ok(z_addr) => z_addr.to_string(),
        Err(_) => String::new(),
    }
}

pub fn store_contact(id: u32, name: &str, address: &str, dirty: bool) {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        wallet.store_contact(id, name, address, dirty)?;
        Ok(())
    };
    log_result(res())
}

pub fn commit_unsaved_contacts(account: u32, anchor_offset: u32) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_lock(&WALLET)?;
        wallet.commit_unsaved_contacts(account, anchor_offset).await
    });
    log_result_string(res)
}

pub fn truncate_data() {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        wallet.truncate_data()?;
        Ok(())
    };
    log_result(res())
}

pub fn delete_account(account: u32) {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        wallet.delete_account(account)?;
        Ok(())
    };
    log_result(res())
}

pub fn make_payment_uri(address: &str, amount: u64, memo: &str) -> String {
    let res = || {
        let uri = Wallet::make_payment_uri(address, amount, memo)?;
        Ok(uri)
    };
    log_result(res())
}

pub fn parse_payment_uri(uri: &str) -> String {
    let res = || {
        let payment_json = Wallet::parse_payment_uri(uri)?;
        Ok(payment_json)
    };
    log_result(res())
}

pub fn generate_random_enc_key() -> String {
    log_result(sync::generate_random_enc_key())
}

pub fn get_full_backup(key: &str) -> String {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        let backup = wallet.get_full_backup(key)?;
        Ok(backup)
    };
    log_result(res())
}

pub fn restore_full_backup(key: &str, backup: &str) -> String {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        wallet.restore_full_backup(key, backup)?;
        Ok(String::new())
    };
    log_result_string(res())
}

pub fn store_share_secret(account: u32, secret: &str) {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        let share = SecretShare::decode(secret)?;
        wallet.store_share_secret(
            account,
            secret,
            share.index,
            share.threshold,
            share.participants,
        )?;
        Ok(())
    };
    log_result(res())
}

pub fn get_share_secret(account: u32) -> String {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        let secret = wallet.get_share_secret(account)?;
        Ok(secret)
    };
    log_result(res())
}

struct MultisigAggregator {
    shutdown_signal: Option<tokio::sync::oneshot::Sender<()>>,
}

impl MultisigAggregator {
    pub fn new() -> Self {
        MultisigAggregator {
            shutdown_signal: None,
        }
    }
}

pub fn run_aggregator(secret_share: &str, port: u16, send_port: i64) {
    let runtime = get_lock(&RUNTIME).unwrap();
    let res = runtime.block_on(async {
        let mut aggregator = get_lock(&MULTISIG_AGG_LOCK)?;
        let (shutdown, _jh) = run_aggregator_service(
            port,
            secret_share,
            Box::new(move || {
                let mut null = ().into_dart();
                unsafe {
                    POST_COBJ.map(|p| {
                        p(send_port, &mut null);
                    });
                }
            }),
        )
        .await?;
        aggregator.shutdown_signal = Some(shutdown);
        Ok(())
    });
    log_result(res)
}

pub fn shutdown_aggregator() {
    let res = || {
        let mut aggregator = get_lock(&MULTISIG_AGG_LOCK)?;
        let shutdown_signal = aggregator.shutdown_signal.take();
        if let Some(shutdown_signal) = shutdown_signal {
            let _ = shutdown_signal.send(());
        }
        Ok(())
    };
    log_result(res())
}

pub fn submit_multisig_tx(tx_str: &str, port: u16) -> Vec<u8> {
    let r = get_runtime();
    let res: anyhow::Result<_> = r.block_on(async {
        let raw_tx = submit_tx(port, tx_str).await?;
        Ok(raw_tx)
    });
    let mut v: Vec<u8> = vec![];
    match res {
        Ok(raw_tx) => {
            v.push(0x00);
            v.extend(raw_tx);
        }
        Err(e) => {
            v.push(0x01);
            v.extend(e.to_string().as_bytes());
        }
    }
    v
}

struct MultisigClient {}

impl MultisigClient {
    pub fn new() -> Self {
        MultisigClient {}
    }
}

pub fn run_multi_signer(
    address: &str,
    amount: u64,
    secret_share: &str,
    aggregator_url: &str,
    my_url: &str,
    port: u16,
) -> u32 {
    let runtime = get_lock(&RUNTIME).unwrap();
    let res = runtime.block_on(async {
        let _jh = run_signer_service(port, secret_share, address, amount).await?;
        tokio::time::sleep(Duration::from_secs(3)).await;
        let share = SecretShare::decode(secret_share)?;
        let error_code = signer_connect_to_aggregator(aggregator_url, my_url, share.index).await?;
        Ok(error_code)
    });
    log_result(res)
}

pub fn split_account(threshold: u32, participants: u32, account: u32) -> String {
    let res = || {
        let wallet = get_lock(&WALLET)?;
        let sk = wallet.get_sk(account)?;
        let shares = zcash_multisig::split_account(threshold as usize, participants as usize, &sk)?;
        Ok(shares)
    };
    log_result(res())
}
