use std::{thread, time::Duration};

use anyhow::Result;

use flutter_rust_bridge::{frb, spawn_blocking_with};
use zcash_vote::db::{load_prop, store_prop};

use crate::{db::open_db, frb_generated::{StreamSink, FLUTTER_RUST_BRIDGE_HANDLER}};

use super::{AppState, DBS};

pub async fn create_election(filepath: String, urls: String, key: String) -> Result<Election> {
    // TODO: Split urls
    let e: zcash_vote::election::Election = reqwest::get(&urls).await?.json().await?;
    let pool = open_db(&filepath, true)?;
    let connection = pool.get()?;
    store_prop(&connection, "urls", &urls)?;
    store_prop(&connection, "election", &serde_json::to_string(&e)?)?;
    store_prop(&connection, "key", &key)?;

    let mut dbs = DBS.lock().unwrap();
    dbs.insert(filepath, AppState {
        pool,
    });

    let e2 = Election::from(e);
    Ok(e2)
}

pub fn get_election(filepath: String) -> Result<Election> {
    let pool = open_db(&filepath, false)?;

    let connection = pool.get()?;
    let e = load_prop(&connection, "election")?.expect("Missing election");
    let e: zcash_vote::election::Election = serde_json::from_str(&e).expect("Invalid json");
    let e = Election::from(e);

    let mut dbs = DBS.lock().unwrap();
    dbs.insert(filepath, AppState {
        pool,
    });

    Ok(e)
}

#[tokio::main(flavor = "current_thread")]
pub async fn download(filepath: String, height: StreamSink<u32>) -> Result<()> {
    let pool = {
        let dbs = DBS.lock().unwrap();
        let state = dbs.get(&filepath).expect("No registered election for filepath");
        state.pool.clone()
    };
    spawn_blocking_with(move || {
        let connection = pool.get()?;
        let election = load_prop(&connection, "election")?.expect("Missing election property");
        let election: zcash_vote::election::Election = serde_json::from_str(&election).unwrap();
        for h in election.start_height..=election.end_height {
            let _ = height.add(h);
            thread::sleep(Duration::from_millis(100));
        }

        Ok::<_, anyhow::Error>(())
    }, FLUTTER_RUST_BRIDGE_HANDLER.thread_pool());
    Ok(())
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

impl From<zcash_vote::election::Election> for Election {
    fn from(e: zcash_vote::election::Election) -> Self {
        Election {
            name: e.name,
            start_height: e.start_height,
            end_height: e.end_height,
            question: e.question,
            candidates: e.candidates.into_iter().map(|c| c.choice).collect(),
            signature_required: e.signature_required,
        }
    }
}
