use std::{thread, time::Duration};

use anyhow::Result;

use flutter_rust_bridge::{frb, spawn_blocking_with, spawn_local};
use rusqlite::OptionalExtension;
use zcash_vote::{db::{load_prop, store_prop}, decrypt::to_fvk};

use crate::{db::open_db, frb_generated::{StreamSink, FLUTTER_RUST_BRIDGE_HANDLER}};

use super::{AppState, DBS};

pub async fn create_election(filepath: String, urls: String, lwd_url: String, key: String) -> Result<Election> {
    // TODO: Split urls
    let e: zcash_vote::election::Election = reqwest::get(&urls).await?.json().await?;
    let pool = open_db(&filepath, true)?;
    let connection = pool.get()?;
    store_prop(&connection, "lwd", &lwd_url)?;
    store_prop(&connection, "urls", &urls)?;
    store_prop(&connection, "election", &serde_json::to_string(&e)?)?;
    store_prop(&connection, "key", &key)?;

    let mut dbs = DBS.lock().unwrap();
    dbs.insert(filepath, AppState {
        pool,
    });

    let e2 = Election::from(e, false);
    Ok(e2)
}

pub fn get_election(filepath: String) -> Result<Election> {
    let pool = open_db(&filepath, false)?;

    let connection = pool.get()?;
    let e = load_prop(&connection, "election")?.expect("Missing election");
    let e: zcash_vote::election::Election = serde_json::from_str(&e).expect("Invalid json");

    let exists = connection.query_row(
        "SELECT 1 FROM cmxs", [], |_| Ok(())).optional()?;

    let e = Election::from(e, exists.is_some());

    let mut dbs = DBS.lock().unwrap();
    dbs.insert(filepath, AppState {
        pool,
    });

    Ok(e)
}

pub async fn download(filepath: String, height: StreamSink<u32>) -> Result<()> {
    let pool = {
        let dbs = DBS.lock().unwrap();
        let state = dbs.get(&filepath).expect("No registered election for filepath");
        state.pool.clone()
    };
    tokio::spawn(async move {
        let connection = pool.get()?;
        let lwd_url = load_prop(&connection, "lwd")?.expect("Missing lightwalletd url");
        let election = load_prop(&connection, "election")?.expect("No election");
        let election: zcash_vote::election::Election = serde_json::from_str(&election).unwrap();
        let seed = load_prop(&connection, "key")?.expect("No key");
        let fvk = to_fvk(&seed)?;

        zcash_vote::download::download_reference_data(connection,
            0, &election, Some(fvk),
            &lwd_url, move |h| {
                let _ = height.add(h);
            }).await?;

        Ok::<_, anyhow::Error>(())
    });
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
    pub downloaded: bool,
}

impl Election {
    fn from(e: zcash_vote::election::Election, downloaded: bool) -> Self {
        Election {
            name: e.name,
            start_height: e.start_height,
            end_height: e.end_height,
            question: e.question,
            candidates: e.candidates.into_iter().map(|c| c.choice).collect(),
            signature_required: e.signature_required,
            downloaded,
        }
    }
}
