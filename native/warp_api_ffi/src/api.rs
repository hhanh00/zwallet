use crate::POST_COBJ;
use allo_isolate::IntoDart;
use android_logger::Config;
use log::{error, info, Level};
use once_cell::sync::OnceCell;
use std::fs::File;
use std::io::Read;
use std::sync::{Mutex, MutexGuard};
use sync::{
    broadcast_tx, decrypt_backup, encrypt_backup, get_coin_type, ChainError, CoinType, KeyHelpers,
    MemPool, Wallet,
};
use tokio::runtime::Runtime;
use tokio::time::Duration;
use zcash_multisig::{
    run_aggregator_service, run_signer_service, signer_connect_to_aggregator, submit_tx,
    SecretShare,
};
use zcash_primitives::transaction::builder::Progress;

static RUNTIME: OnceCell<Mutex<Runtime>> = OnceCell::new();
static YWALLET: OnceCell<Mutex<Wallet>> = OnceCell::new();
static ZWALLET: OnceCell<Mutex<Wallet>> = OnceCell::new();
static YMEMPOOL: OnceCell<Mutex<MemPool>> = OnceCell::new();
static ZMEMPOOL: OnceCell<Mutex<MemPool>> = OnceCell::new();
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

pub fn init_wallet(db_path: &str) {
    android_logger::init_once(Config::default().with_min_level(Level::Info));
    info!("Init");
    RUNTIME.get_or_init(|| Mutex::new(Runtime::new().unwrap()));
    YWALLET.get_or_init(|| {
        info!("YWallet Init");
        let wallet = Wallet::new(CoinType::Ycash, &format!("{}/yec.db", db_path));
        Mutex::new(wallet)
    });
    ZWALLET.get_or_init(|| {
        info!("ZWallet Init");
        let wallet = Wallet::new(CoinType::Zcash, &format!("{}/zec.db", db_path));
        Mutex::new(wallet)
    });
    YMEMPOOL.get_or_init(|| {
        info!("YMempool Init");
        let mempool = MemPool::new(CoinType::Ycash, &format!("{}/yec.db", db_path));
        Mutex::new(mempool)
    });
    ZMEMPOOL.get_or_init(|| {
        info!("ZMempool Init");
        let mempool = MemPool::new(CoinType::Zcash, &format!("{}/zec.db", db_path));
        Mutex::new(mempool)
    });
    SYNCLOCK.get_or_init(|| Mutex::new(()));
    MULTISIG_AGG_LOCK.get_or_init(|| Mutex::new(MultisigAggregator::new()));
    MULTISIG_SIGN_LOCK.get_or_init(|| Mutex::new(MultisigClient::new()));
}

pub fn reset_app() {
    let res = || {
        let wallet = get_lock(&YWALLET)?;
        wallet.reset_db()?;
        let wallet = get_lock(&ZWALLET)?;
        wallet.reset_db()?;
        Ok(())
    };
    log_result(res())
}

pub fn new_account(coin: u8, name: &str, data: &str, index: u32) -> i32 {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
        wallet.new_account(name, data, index)
    };
    log_result(res())
}

pub fn new_sub_account(coin: u8, id: u32, name: &str) -> i32 {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
        let id = wallet.new_sub_account(id, name)?;
        Ok(id)
    };
    log_result(res())
}

fn get_wallet_lock(coin: u8) -> anyhow::Result<MutexGuard<'static, Wallet>> {
    match coin {
        1 => get_lock(&YWALLET),
        _ => get_lock(&ZWALLET),
    }
}

fn get_mempool_lock(coin: u8) -> anyhow::Result<MutexGuard<'static, MemPool>> {
    match coin {
        1 => get_lock(&YMEMPOOL),
        _ => get_lock(&ZMEMPOOL),
    }
}

async fn warp(
    coin: u8,
    get_tx: bool,
    anchor_offset: u32,
    db_path: &str,
    ld_url: &str,
    port: i64,
) -> anyhow::Result<()> {
    info!("Sync started");
    let coin_type = get_coin_type(coin);
    Wallet::sync_ex(
        coin_type,
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
    let mut mempool = get_mempool_lock(coin)?;
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

pub fn warp_sync(coin: u8, get_tx: bool, anchor_offset: u32, port: i64) -> i8 {
    let r = get_runtime();
    let res = r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let _sync_lock = get_lock(&SYNCLOCK)?;
        let wallet = get_wallet_lock(coin)?;
        let db_path = wallet.db_path.clone();
        let ld_url = wallet.ld_url.clone();
        drop(wallet);
        warp(coin, get_tx, anchor_offset, &db_path, &ld_url, port).await?;
        Ok::<_, anyhow::Error>(())
    });
    convert_sync_result(res)
}

// pub fn try_warp_sync(coin: u8, get_tx: bool, anchor_offset: u32) -> i8 {
//     let r = get_runtime();
//     let res = r.block_on(async {
//         android_logger::init_once(Config::default().with_min_level(Level::Info));
//         let _sync_lock = SYNCLOCK
//             .get()
//             .ok_or_else(|| anyhow::anyhow!("Lock not initialized"))?
//             .try_lock();
//         if _sync_lock.is_ok() {
//             let wallet = get_wallet_lock(coin)?;
//             let db_path = wallet.db_path.clone();
//             let ld_url = wallet.ld_url.clone();
//             drop(wallet);
//             warp(coin, get_tx, anchor_offset, &db_path, &ld_url, 0).await?;
//             Ok::<_, anyhow::Error>(())
//         } else {
//             Err(anyhow::anyhow!(ChainError::Busy))
//         }
//     });
//     convert_sync_result(res)
// }

pub fn is_valid_key(coin: u8, seed: &str) -> i8 {
    let coin_type = get_coin_type(coin);
    let kh = KeyHelpers::new(coin_type);
    kh.is_valid_key(seed)
}

pub fn valid_address(coin: u8, address: &str) -> bool {
    let coin_type = get_coin_type(coin);
    let kh = KeyHelpers::new(coin_type);
    kh.valid_address(address)
}

pub fn new_address(coin: u8, account: u32) -> String {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
        wallet.new_diversified_address(account)
    };
    log_result(res())
}

pub fn get_latest_height(coin: u8) -> u32 {
    let r = get_runtime();
    let res = r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let wallet = get_wallet_lock(coin)?;
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
    coin: u8,
    account: u32,
    recipients_json: &str,
    use_transparent: bool,
    anchor_offset: u32,
    port: i64,
) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_wallet_lock(coin)?;
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

pub fn skip_to_last_height(coin: u8) {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_wallet_lock(coin)?;
        wallet.skip_to_last_height().await
    });
    log_result(res)
}

pub fn rewind_to_height(coin: u8, height: u32) {
    let res = || {
        let mut wallet = get_wallet_lock(coin)?;
        wallet.rewind_to_height(height)
    };
    log_result(res())
}

pub fn mempool_sync(coin: u8) -> i64 {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut mempool = get_mempool_lock(coin)?;
        mempool.scan().await
    });
    log_result(res)
}

pub fn set_mempool_account(coin: u8, account: u32) {
    let res = || {
        let mut mempool = get_mempool_lock(coin)?;
        mempool.set_account(account)
    };
    log_result(res());
}

pub fn mempool_reset(coin: u8, height: u32) {
    let res = || {
        let mut mempool = get_mempool_lock(coin)?;
        mempool.clear(height)
    };
    log_result(res());
}

pub fn get_mempool_balance(coin: u8) -> i64 {
    let res = || {
        let mempool = get_mempool_lock(coin)?;
        Ok(mempool.get_unconfirmed_balance())
    };
    log_result(res())
}

pub fn get_taddr_balance(coin: u8, account: u32) -> u64 {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_wallet_lock(coin)?;
        wallet.get_taddr_balance(account).await
    });
    log_result(res)
}

pub fn shield_taddr(coin: u8, account: u32) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_wallet_lock(coin)?;
        let height = sync::latest_height(&wallet.ld_url).await?;
        wallet.shield_taddr(account, height).await
    });
    log_result(res)
}

pub fn set_lwd_url(coin: u8, url: &str) {
    let res = || {
        let mut wallet = get_wallet_lock(coin)?;
        wallet.set_lwd_url(url)?;
        let mut mempool = get_mempool_lock(coin)?;
        mempool.set_lwd_url(url)?;
        Ok(())
    };
    log_result(res())
}

pub fn prepare_multi_payment(
    coin: u8,
    account: u32,
    recipients_json: &str,
    use_transparent: bool,
    anchor_offset: u32,
) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_wallet_lock(coin)?;
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

pub fn broadcast(coin: u8, tx_filename: &str) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_wallet_lock(coin)?;
        let mut file = File::open(&tx_filename)?;
        let mut s = String::new();
        file.read_to_string(&mut s)?;
        let tx = hex::decode(s.trim_end())?;
        broadcast_tx(&tx, &wallet.ld_url).await
    });
    log_result_string(res)
}

pub fn broadcast_txhex(coin: u8, txhex: &str) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_wallet_lock(coin)?;
        let tx = hex::decode(txhex)?;
        broadcast_tx(&tx, &wallet.ld_url).await
    });
    log_result_string(res)
}

pub fn sync_historical_prices(coin: u8, now: i64, days: u32, currency: &str) -> u32 {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_wallet_lock(coin)?;
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

pub fn store_contact(coin: u8, id: u32, name: &str, address: &str, dirty: bool) {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
        wallet.store_contact(id, name, address, dirty)?;
        Ok(())
    };
    log_result(res())
}

pub fn commit_unsaved_contacts(coin: u8, account: u32, anchor_offset: u32) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_wallet_lock(coin)?;
        wallet.commit_unsaved_contacts(account, anchor_offset).await
    });
    log_result_string(res)
}

pub fn truncate_data(coin: u8) {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
        wallet.truncate_data()?;
        Ok(())
    };
    log_result(res())
}

pub fn delete_account(coin: u8, account: u32) {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
        wallet.delete_account(account)?;
        Ok(())
    };
    log_result(res())
}

pub fn make_payment_uri(coin: u8, address: &str, amount: u64, memo: &str) -> String {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
        let uri = wallet.make_payment_uri(address, amount, memo)?;
        Ok(uri)
    };
    log_result(res())
}

pub fn parse_payment_uri(coin: u8, uri: &str) -> String {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
        let payment_json = wallet.parse_payment_uri(uri)?;
        Ok(payment_json)
    };
    log_result(res())
}

pub fn generate_random_enc_key() -> String {
    log_result(sync::generate_random_enc_key())
}

pub fn get_full_backup(key: &str) -> String {
    let res = || {
        let mut accounts = vec![];
        for coin in [0, 1] {
            let wallet = get_wallet_lock(coin)?;
            accounts.extend(wallet.get_full_backup()?);
        }

        let backup = encrypt_backup(&accounts, key)?;
        Ok(backup)
    };
    log_result(res())
}

pub fn restore_full_backup(key: &str, backup: &str) -> String {
    let res = || {
        let accounts = decrypt_backup(key, backup)?;
        for coin in [0, 1] {
            let wallet = get_wallet_lock(coin)?;
            wallet.restore_full_backup(&accounts)?;
        }
        Ok(String::new())
    };
    log_result_string(res())
}

pub fn store_share_secret(coin: u8, account: u32, secret: &str) {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
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

pub fn get_share_secret(coin: u8, account: u32) -> String {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
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

pub fn split_account(coin: u8, threshold: u32, participants: u32, account: u32) -> String {
    let res = || {
        let wallet = get_wallet_lock(coin)?;
        let sk = wallet.get_sk(account)?;
        let shares = zcash_multisig::split_account(threshold as usize, participants as usize, &sk)?;
        Ok(shares)
    };
    log_result(res())
}
