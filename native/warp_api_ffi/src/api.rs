use crate::POST_COBJ;
use allo_isolate::IntoDart;
use android_logger::Config;
use log::{error, info, Level};
use once_cell::sync::OnceCell;
use std::fs::File;
use std::io::{Read, Write};
use std::sync::Mutex;
use sync::{broadcast_tx, ChainError, MemPool, Wallet};
use tokio::runtime::Runtime;
use zcash_primitives::transaction::builder::Progress;

static WALLET: OnceCell<Mutex<Wallet>> = OnceCell::new();
static MEMPOOL: OnceCell<Mutex<MemPool>> = OnceCell::new();
static SYNCLOCK: OnceCell<Mutex<()>> = OnceCell::new();

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

pub fn new_account(name: &str, data: &str) -> u32 {
    let wallet = WALLET.get().unwrap().lock().unwrap();
    log_result(wallet.new_account(name, data))
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
    let mut mempool = MEMPOOL.get().unwrap().lock().unwrap();
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
    let r = Runtime::new().unwrap();
    let res = r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let _sync_lock = SYNCLOCK.get().unwrap().lock().unwrap();
        let wallet = WALLET.get().unwrap().lock().unwrap();
        let db_path = wallet.db_path.clone();
        let ld_url = wallet.ld_url.clone();
        drop(wallet);
        warp(get_tx, anchor_offset, &db_path, &ld_url, port).await?;
        Ok::<_, anyhow::Error>(())
    });
    convert_sync_result(res)
}

pub fn try_warp_sync(get_tx: bool, anchor_offset: u32) -> i8 {
    let r = Runtime::new().unwrap();
    let res = r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let _sync_lock = SYNCLOCK.get().unwrap().try_lock();
        if _sync_lock.is_ok() {
            let wallet = WALLET.get().unwrap().lock().unwrap();
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
    let wallet = WALLET.get().unwrap().lock().unwrap();
    wallet.new_diversified_address(account).unwrap()
}

pub fn get_latest_height() -> u32 {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let wallet = WALLET.get().unwrap().lock().unwrap();
        log_result(sync::latest_height(&wallet.ld_url).await)
    })
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
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let wallet = WALLET.get().unwrap().lock().unwrap();
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
            .await;
        match res {
            Err(err) => {
                log::error!("{}", err);
                err.to_string()
            }
            Ok(tx_id) => tx_id,
        }
    })
}

pub fn send_multi_payment(
    account: u32,
    recipients_json: &str,
    anchor_offset: u32,
    port: i64,
) -> String {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let wallet = WALLET.get().unwrap().lock().unwrap();
        let res = wallet
            .send_multi_payment(account, recipients_json, anchor_offset, move |progress| {
                report_progress(progress, port);
            })
            .await;
        log_result_string(res)
    })
}

pub fn skip_to_last_height() {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let wallet = WALLET.get().unwrap().lock().unwrap();
        log_result(wallet.skip_to_last_height().await);
    });
}

pub fn rewind_to_height(height: u32) {
    let mut wallet = WALLET.get().unwrap().lock().unwrap();
    log_result(wallet.rewind_to_height(height))
}

pub fn mempool_sync() -> i64 {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let mut mempool = MEMPOOL.get().unwrap().lock().unwrap();
        let res = mempool.scan().await;
        log_result(res)
    })
}

pub fn set_mempool_account(account: u32) {
    let mut mempool = MEMPOOL.get().unwrap().lock().unwrap();
    log_result(mempool.set_account(account));
}

pub fn mempool_reset(height: u32) {
    let mut mempool = MEMPOOL.get().unwrap().lock().unwrap();
    log_result(mempool.clear(height));
}

pub fn get_mempool_balance() -> i64 {
    let mempool = MEMPOOL.get().unwrap().lock().unwrap();
    mempool.get_unconfirmed_balance()
}

pub fn get_taddr_balance(account: u32) -> u64 {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let wallet = WALLET.get().unwrap().lock().unwrap();
        let res = wallet.get_taddr_balance(account).await;
        log_result(res)
    })
}

pub fn shield_taddr(account: u32) -> String {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let wallet = WALLET.get().unwrap().lock().unwrap();
        let res = wallet.shield_taddr(account).await;
        log_result(res)
    })
}

pub fn set_lwd_url(url: &str) {
    let mut wallet = WALLET.get().unwrap().lock().unwrap();
    log_result(wallet.set_lwd_url(url));
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
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let wallet = WALLET.get().unwrap().lock().unwrap();
        let res = wallet
            .prepare_payment(
                account,
                to_address,
                amount,
                memo,
                max_amount_per_note,
                anchor_offset,
            )
            .await;
        match res {
            Ok(tx) => {
                let mut file = File::create(tx_filename).unwrap();
                writeln!(file, "{}", tx).unwrap();
                "File saved".to_string()
            }
            Err(err) => {
                log::error!("{}", err);
                format!("{}", err)
            }
        }
    })
}

async fn _broadcast(tx_filename: &str, ld_url: &str) -> anyhow::Result<String> {
    let mut file = File::open(&tx_filename)?;
    let mut s = String::new();
    file.read_to_string(&mut s)?;
    let tx = hex::decode(s.trim_end())?;
    broadcast_tx(&tx, ld_url).await
}

pub fn broadcast(tx_filename: &str) -> String {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let wallet = WALLET.get().unwrap().lock().unwrap();
        let res = _broadcast(tx_filename, &wallet.ld_url).await;
        log_result_string(res)
    })
}

pub fn sync_historical_prices(now: i64, days: u32, currency: &str) -> u32 {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let mut wallet = WALLET.get().unwrap().lock().unwrap();
        let res = wallet.sync_historical_prices(now, days, currency).await;
        log_result(res)
    })
}

pub fn get_ua(sapling_addr: &str, transparent_addr: &str) -> String {
    let ua = sync::get_ua(sapling_addr, transparent_addr).unwrap();
    ua.to_string()
}

pub fn get_sapling(ua_addr: &str) -> String {
    let z_addr = sync::get_sapling(ua_addr);
    match z_addr {
        Ok(z_addr) => z_addr.to_string(),
        Err(_) => String::new(),
    }
}
