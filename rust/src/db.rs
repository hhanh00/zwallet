use anyhow::Result;
use r2d2::Pool;
use r2d2_sqlite::SqliteConnectionManager;
use rusqlite::Connection;
use zcash_vote::db::create_schema;

pub fn open_db(path: &str, new: bool) -> Result<Pool<SqliteConnectionManager>> {
  if new { 
    let _ = std::fs::remove_file(path); // ignore failure
  }
  
  {
    let connection = Connection::open(path)?;
    create_schema(&connection)?; // create the base schema
    connection.execute(
        "CREATE TABLE IF NOT EXISTS votes(
        id_vote INTEGER PRIMARY KEY,
        hash TEXT NOT NULL,
        address TEXT NOT NULL,
        amount INTEGER NOT NULL,
        height INTEGER)",
        [],
    )?;
  }

  let manager = SqliteConnectionManager::file(&path);
  let pool = Pool::new(manager)?;

  Ok(pool)
}
