use std::{collections::HashMap, sync::Mutex};

use flutter_rust_bridge::frb;
use r2d2::Pool;
use r2d2_sqlite::SqliteConnectionManager;
use zcash_vote::db::store_prop;

use crate::db::open_db;

pub async fn create_election(filepath: String, urls: String, key: String) -> anyhow::Result<Election> {
    // TODO: Split urls
    let e: zcash_vote::election::Election = reqwest::get(&urls).await?.json().await?;
    let pool = open_db(&filepath, true)?;
    let connection = pool.get()?;
    store_prop(&connection, "urls", &urls)?;
    store_prop(&connection, "election", &serde_json::to_string(&e)?)?;
    store_prop(&connection, "key", &key)?;

    let mut dbs = DBS.lock().unwrap();
    dbs.insert(filepath, State {
        pool,
    });

    let e2 = Election {
        name: e.name,
        start_height: e.start_height,
        end_height: e.end_height,
        question: e.question,
        candidates: e.candidates.into_iter().map(|c| c.choice).collect(),
        signature_required: e.signature_required,
    };
    Ok(e2)
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

#[frb(dart_metadata=("freezed"))]
pub struct Election {
    pub name: String,
    pub start_height: u32,
    pub end_height: u32,
    pub question: String,
    pub candidates: Vec<String>,
    pub signature_required: bool,
}

#[derive(Clone)]
pub struct State {
    pub pool: Pool<SqliteConnectionManager>,
}

lazy_static::lazy_static! {
    pub static ref DBS: Mutex<HashMap<String, State>> = 
        Mutex::new(HashMap::new());
}
