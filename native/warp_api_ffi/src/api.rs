use crate::POST_COBJ;
use allo_isolate::IntoDart;
use android_logger::Config;
use log::{error, info, Level};
use once_cell::sync::OnceCell;
use std::fs::File;
use std::io::{Read, Write};
use std::sync::{Mutex, MutexGuard};
use sync::{broadcast_tx, ChainError, MemPool, Wallet};
use tokio::runtime::Runtime;
use zcash_primitives::transaction::builder::Progress;

static WALLET: OnceCell<Mutex<Wallet>> = OnceCell::new();
static MEMPOOL: OnceCell<Mutex<MemPool>> = OnceCell::new();
static SYNCLOCK: OnceCell<Mutex<()>> = OnceCell::new();

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

pub fn send_payment(
    account: u32,
    address: &str,
    amount: u64,
    memo: &str,
    max_amount_per_note: u64,
    anchor_offset: u32,
    shield_transparent_balance: bool,
    port: i64,
) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_lock(&WALLET)?;
        let res = wallet
            .send_payment(
                account,
                address,
                amount,
                memo,
                max_amount_per_note,
                anchor_offset,
                shield_transparent_balance,
                move |progress| {
                    report_progress(progress, port);
                },
            )
            .await?;
        Ok(res)
    });
    log_result_string(res)
}

pub fn send_multi_payment(
    account: u32,
    recipients_json: &str,
    anchor_offset: u32,
    port: i64,
) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let mut wallet = get_lock(&WALLET)?;
        let res = wallet
            .send_multi_payment(account, recipients_json, anchor_offset, move |progress| {
                report_progress(progress, port);
            })
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
        let wallet = get_lock(&WALLET)?;
        wallet.shield_taddr(account).await
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

pub fn prepare_offline_tx(
    account: u32,
    to_address: &str,
    amount: u64,
    memo: &str,
    max_amount_per_note: u64,
    anchor_offset: u32,
    tx_filename: &str,
) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_lock(&WALLET)?;
        let tx = wallet
            .prepare_payment(
                account,
                to_address,
                amount,
                memo,
                max_amount_per_note,
                anchor_offset,
            )
            .await?;
        let mut file = File::create(tx_filename)?;
        writeln!(file, "{}", tx)?;
        Ok("File saved".to_string())
    });
    log_result_string(res)
}

async fn _broadcast(tx_filename: &str, ld_url: &str) -> anyhow::Result<String> {
    let mut file = File::open(&tx_filename)?;
    let mut s = String::new();
    file.read_to_string(&mut s)?;
    let tx = hex::decode(s.trim_end())?;
    broadcast_tx(&tx, ld_url).await
}

pub fn broadcast(tx_filename: &str) -> String {
    let r = get_runtime();
    let res = r.block_on(async {
        let wallet = get_lock(&WALLET)?;
        _broadcast(tx_filename, &wallet.ld_url).await
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
        let wallet = get_lock(&WALLET)?;
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
