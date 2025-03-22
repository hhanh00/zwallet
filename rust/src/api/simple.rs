use std::{thread, time::Duration};

use anyhow::Result;

use flutter_rust_bridge::{frb, spawn_blocking_with, spawn_local};
use orchard::{keys::{PreparedIncomingViewingKey, Scope}, vote::{try_decrypt_ballot, Ballot}};
use rand_core::RngCore;
use reqwest::header::CONTENT_TYPE;
use rusqlite::{params, Connection, OptionalExtension};
use zcash_vote::{address::VoteAddress, db::{list_notes, load_prop, mark_spent, store_cmx, store_note, store_prop}, decrypt::{to_fvk, to_sk}, election::{BALLOT_PK, BALLOT_VK}, trees::{list_cmxs, list_nf_ranges}};

use crate::{db::open_db, frb_generated::{StreamSink, FLUTTER_RUST_BRIDGE_HANDLER}};

use super::{AppState, DBS};

pub async fn create_election(filepath: String, urls: String, lwd_url: String, key: String) -> Result<Election> {
    let urls_split: Vec<&str> = urls.split(",").collect();
    let mut rng = rand_core::OsRng;
    let i = rng.next_u64() as usize % urls_split.len();
    let random_url = urls_split[i];
    let e: zcash_vote::election::Election = reqwest::get(random_url).await?.json().await?;
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

pub fn get_balance(filepath: String) -> Result<u64> {
    let pool = {
        let dbs = DBS.lock().unwrap();
        let state = dbs.get(&filepath).expect("No registered election for filepath");
        state.pool.clone()
    };
    let connection = pool.get()?;
    let balance = connection.query_row(
        "SELECT SUM(value) FROM notes WHERE spent IS NULL",
        [],
        |r| r.get::<_, Option<u64>>(0),
    )?.unwrap_or_default();
    Ok(balance)
}

pub async fn vote(filepath: String, index_candidate: u32, amount: u64) -> Result<String> {
    let pool = {
        let dbs = DBS.lock().unwrap();
        let state = dbs.get(&filepath).expect("No registered election for filepath");
        state.pool.clone()
    };
    let connection = pool.get()?;
    let election = load_prop(&connection, "election")?.expect("No election");
    let election: zcash_vote::election::Election = serde_json::from_str(&election).unwrap();
    let seed = load_prop(&connection, "key")?.expect("No key");
    let sk = to_sk(&seed)?;
    let fvk = to_fvk(&seed)?;
    let domain = election.domain();
    let signature_required = election.signature_required;

    let mut rng = rand_core::OsRng;
    let choice = &election.candidates[index_candidate as usize];
    let vaddress = VoteAddress::decode(&choice.address)?;
    let notes = list_notes(&connection, 0, &fvk)?;
    let cmxs = list_cmxs(&connection)?;
    let nfs = list_nf_ranges(&connection)?;
    let ballot = orchard::vote::vote(
        domain,
        signature_required,
        sk,
        &fvk,
        vaddress.0,
        amount,
        &notes,
        &nfs,
        &cmxs,
        &mut rng,
        &BALLOT_PK,
        &BALLOT_VK,
    )?;
    let sighash = ballot.data.sighash()?;
    let id = hex::encode(&sighash);

    let client = reqwest::Client::new();
    let mut hash = String::new();
    let mut error = String::new();
    let mut success = false;
    let base_urls = load_prop(&connection, "urls")?.expect("Missing urls");
    let base_urls = base_urls.split(",");
    for base_url in base_urls {
        let url = format!("{}/ballot", base_url);
        let rep = client
            .post(url)
            .header(CONTENT_TYPE, "application/json")
            .json(&ballot)
            .send()
            .await?;
        let s = rep.status().is_success();
        let res = rep.text().await?;
        if s {
            success = true;
        }
        else {
            tracing::info!("ERROR (transient): {error}");
            error = res;
            continue;
        }

        if hash.is_empty() {
            hash = hex::encode(ballot.data.sighash()?);
            // crate::db::store_vote(&connection, &hash, &address, amount)?;
        }
    }
    if !success {
        anyhow::bail!(error);
    }

    Ok(id)
}

pub async fn synchronize(filepath: String) -> Result<()> {
    let pool = {
        let dbs = DBS.lock().unwrap();
        let state = dbs.get(&filepath).expect("No registered election for filepath");
        state.pool.clone()
    };
    let connection = pool.get()?;
    let urls = load_prop(&connection, "urls")?.expect("No urls");
    let urls_split: Vec<&str> = urls.split(",").collect();
    let mut rng = rand_core::OsRng;
    let i = rng.next_u64() as usize % urls_split.len();
    let random_url = urls_split[i];

    let url = format!("{}/num_ballots", random_url);
    let n = reqwest::get(url).await?.text().await?;
    let n = n.parse::<u32>()?;
    let election = load_prop(&connection, "election")?.expect("No election JSON");
    let election: zcash_vote::election::Election = serde_json::from_str(&election)?;
    let c = connection.query_row("SELECT COUNT(*) FROM ballots", [], |r| r.get::<_, u32>(0))?;
    if c < n {
        for i in c..n {
            let url = format!("{}/ballot/height/{}", random_url, i + 1);
            let ballot = reqwest::get(url).await?.text().await?;
            let ballot: Ballot = serde_json::from_str(&ballot)?;

            let mut connection = pool.get()?;
            let transaction = connection.transaction()?;
            handle_ballot(&transaction, &election, i + 1, &ballot)?;
            store_ballot(&transaction, i + 1, &ballot)?;
            transaction.commit()?;
        }
    }

    Ok(())
}

fn handle_ballot(
    connection: &Connection,
    election: &zcash_vote::election::Election,
    height: u32,
    ballot: &Ballot,
) -> Result<()> {
    let key = load_prop(connection, "key")?.ok_or(anyhow::anyhow!("no key"))?;
    let fvk = to_fvk(&key)?;
    let pivk = PreparedIncomingViewingKey::new(&fvk.to_ivk(Scope::External));

    let position = connection.query_row("SELECT COUNT(*) FROM cmxs", [], |r| r.get::<_, u32>(0))?;
    let txid = ballot.data.sighash()?;

    for (i, action) in ballot.data.actions.iter().enumerate() {
        connection.execute(
            "UPDATE notes SET spent = ?1 WHERE dnf = ?2",
            params![height, &action.nf],
        )?;

        if let Some(note) = try_decrypt_ballot(&pivk, action)? {
            store_note(
                connection,
                0,
                election.domain(),
                &fvk,
                height,
                position + i as u32,
                &txid,
                &note,
            )?;
        }
        store_cmx(connection, 0, &action.cmx)?;
    }
    Ok(())
}

fn store_ballot(connection: &Connection, height: u32, ballot: &Ballot) -> Result<()> {
    let hash = ballot.data.sighash()?;
    let ballot = serde_json::to_string(ballot)?;
    connection.execute(
        "INSERT INTO ballots(election, height, hash, data)
        VALUES (?1, ?2, ?3, ?4)",
        params![0, height, &hash, &ballot],
    )?;
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
