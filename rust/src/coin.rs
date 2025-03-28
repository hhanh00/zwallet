use anyhow::Result;
use rusqlite::OptionalExtension;
use std::sync::Mutex;

use lazy_static::lazy_static;
use r2d2::Pool;
use r2d2_sqlite::SqliteConnectionManager;
use zcash_primitives::consensus::Network;

#[derive(Clone)]
pub struct Coin {
    pub coin: u8,
    pub network: Network,
    pub pool: Pool<SqliteConnectionManager>,
    pub password: String,
}

impl Coin {
    pub fn new(coin: u8, filepath: &str, password: &str) -> Result<Coin> {
        let manager = SqliteConnectionManager::file(filepath);
        let pool = Pool::new(manager)?;
        let connection = pool.get().unwrap();
        if !password.is_empty() {
            connection.query_row(&format!("PRAGMA KEY = '{}'", &password), [], |_| Ok(())).optional()?;
        }
        let network = match coin {
            0 => Network::MainNetwork,
            1 => Network::YCashMainNetwork,
            _ => unreachable!(),
        };
        let coin_info = Coin {
            coin,
            network,
            pool,
            password: password.to_string(),
        };
        Ok(coin_info)
    }
}

#[macro_export]
macro_rules! with_coin {
    ($coin: ident, $network: tt, $connection: tt, $body: expr) => {{
        use rusqlite::OptionalExtension as _;

        let c = {
            let coins = crate::coin::COINS.lock().unwrap();
            let coin_info = &coins[$coin as usize];
            coin_info.clone()
        };
        let pool = c.pool;
        let $network = c.network;
        let $connection = pool.get().unwrap();
        if !c.password.is_empty() {
            $connection.query_row(&format!("PRAGMA KEY = '{}'", &c.password), [], |_| Ok(())).optional()?;
        }

        $body
    }};
}

lazy_static! {
    pub static ref COINS: Mutex<[Coin; 2]> = Mutex::new(init_coins());
}

fn init_coins() -> [Coin; 2] {
    [
        Coin::new(0, "", "").unwrap(),
        Coin::new(1, "", "").unwrap(),
    ]
}
