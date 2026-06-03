use anyhow::Result;
use r2d2::Pool;
use r2d2_sqlite::SqliteConnectionManager;
use rusqlite::Connection;

pub fn open_db(path: &str, new: bool) -> Result<Pool<SqliteConnectionManager>> {
  if new {
    let _ = std::fs::remove_file(path); // ignore failure
  }

  {
    let connection = Connection::open(path)?;
  }

  let manager = SqliteConnectionManager::file(&path);
  let pool = Pool::new(manager)?;

  Ok(pool)
}
