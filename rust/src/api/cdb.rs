use anyhow::Result;
use flutter_rust_bridge::frb;
use crate::{coin::Coin, with_coin};


#[frb(sync)]
pub fn coin_open_db(coin: u8, filepath: &str, password: &str) -> Result<()> {
    let c = Coin::new(coin, filepath, password)?;
    let mut cc = crate::coin::COINS.lock().unwrap();
    cc[coin as usize] = c;

    Ok(())
}

#[frb(sync)]
pub fn create_schema(coin: u8) -> Result<()> {
    with_coin!(coin, _, connection, {
        connection.execute(
            "CREATE TABLE IF NOT EXISTS tt(
                i_tt INTEGER PRIMARY KEY NOT NULL,
                v TEXT NOT NULL)", [])?;
        Ok(())
    })
}
