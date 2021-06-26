use crate::POST_COBJ;
use allo_isolate::IntoDart;
use android_logger::Config;
use log::{error, info, Level};
use once_cell::sync::OnceCell;
use std::sync::Mutex;
use sync::{ChainError, MemPool, Wallet};
use tokio::runtime::Runtime;

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

pub fn init_wallet(db_path: &str) {
    android_logger::init_once(Config::default().with_min_level(Level::Info));
    info!("Init");
    WALLET.get_or_init(|| {
        info!("Wallet Init");
        let wallet = Wallet::new(db_path);
        Mutex::new(wallet)
    });
    MEMPOOL.get_or_init(|| {
        info!("Mempool Init");
        let mempool = MemPool::new(db_path);
        Mutex::new(mempool)
    });
    SYNCLOCK.get_or_init(|| Mutex::new(()));
}

pub fn new_account(name: &str, data: &str) -> u32 {
    let wallet = WALLET.get().unwrap().lock().unwrap();
    log_result(wallet.new_account(name, data))
}

async fn warp(db_path: &str, port: i64) -> anyhow::Result<()> {
    info!("Sync started");
    Wallet::sync_ex(&db_path, move |height| {
        let mut height = height.into_dart();
        if port != 0 {
            unsafe {
                POST_COBJ.map(|p| {
                    p(port, &mut height);
                });
            }
        }
    })
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

pub fn warp_sync(port: i64) -> i8 {
    let r = Runtime::new().unwrap();
    let res = r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let _sync_lock = SYNCLOCK.get().unwrap().lock().unwrap();
        let wallet = WALLET.get().unwrap().lock().unwrap();
        let db_path = wallet.db_path.clone();
        drop(wallet);
        warp(&db_path, port).await?;
        Ok::<_, anyhow::Error>(())
    });
    convert_sync_result(res)
}

pub fn try_warp_sync() -> i8 {
    let r = Runtime::new().unwrap();
    let res = r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        let _sync_lock = SYNCLOCK.get().unwrap().try_lock();
        if _sync_lock.is_ok() {
            let wallet = WALLET.get().unwrap().lock().unwrap();
            let db_path = wallet.db_path.clone();
            drop(wallet);
            warp(&db_path, 0).await?;
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

pub fn get_latest_height() -> u32 {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        android_logger::init_once(Config::default().with_min_level(Level::Info));
        log_result(sync::latest_height().await)
    })
}

pub fn send_payment(account: u32, address: &str, amount: u64) -> String {
    let r = Runtime::new().unwrap();
    r.block_on(async {
        let wallet = WALLET.get().unwrap().lock().unwrap();
        let res = wallet.send_payment(account, address, amount).await;
        match res {
            Err(err) => {
                log::error!("{}", err);
                "".to_string()
            }
            Ok(tx_id) => tx_id,
        }
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

pub fn get_mempool_balance() -> i64 {
    let mempool = MEMPOOL.get().unwrap().lock().unwrap();
    mempool.get_unconfirmed_balance()
}
