use std::{collections::HashMap, sync::Mutex};

use flutter_rust_bridge::frb;
use r2d2::Pool;
use r2d2_sqlite::SqliteConnectionManager;

pub mod simple;

#[derive(Clone)]
#[frb(ignore)]
pub struct AppState {
    pub pool: Pool<SqliteConnectionManager>,
}

lazy_static::lazy_static! {
    pub static ref DBS: Mutex<HashMap<String, AppState>> =
        Mutex::new(HashMap::new());
}
