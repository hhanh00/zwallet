CREATE TABLE IF NOT EXISTS schema_version (
    id INTEGER PRIMARY KEY NOT NULL,
    version INTEGER NOT NULL);
CREATE TABLE IF NOT EXISTS accounts (
    id_account INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    seed TEXT,
    aindex INTEGER NOT NULL,
    sk TEXT,
    ivk TEXT NOT NULL UNIQUE,
    address TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS blocks (
    height INTEGER PRIMARY KEY,
    hash BLOB NOT NULL,
    timestamp INTEGER NOT NULL,
    sapling_tree BLOB NOT NULL);

CREATE TABLE IF NOT EXISTS transactions (
    id_tx INTEGER PRIMARY KEY,
    account INTEGER NOT NULL,
    txid BLOB NOT NULL,
    height INTEGER NOT NULL,
    timestamp INTEGER NOT NULL,
    value INTEGER NOT NULL,
    address TEXT,
    memo TEXT,
    tx_index INTEGER,
    CONSTRAINT tx_account UNIQUE (height, tx_index, account));

CREATE TABLE IF NOT EXISTS received_notes (
    id_note INTEGER PRIMARY KEY,
    account INTEGER NOT NULL,
    position INTEGER NOT NULL,
    tx INTEGER NOT NULL,
    height INTEGER NOT NULL,
    output_index INTEGER NOT NULL,
    diversifier BLOB NOT NULL,
    value INTEGER NOT NULL,
    rcm BLOB NOT NULL,
    nf BLOB NOT NULL UNIQUE,
    spent INTEGER,
    excluded BOOL,
    CONSTRAINT tx_output UNIQUE (tx, output_index));

CREATE TABLE IF NOT EXISTS sapling_witnesses (
    id_witness INTEGER PRIMARY KEY,
    note INTEGER NOT NULL,
    height INTEGER NOT NULL,
    witness BLOB NOT NULL,
    CONSTRAINT witness_height UNIQUE (note, height));

CREATE TABLE IF NOT EXISTS diversifiers (
    account INTEGER PRIMARY KEY NOT NULL,
    diversifier_index BLOB NOT NULL);
CREATE TABLE IF NOT EXISTS taddrs (
    account INTEGER PRIMARY KEY NOT NULL,
    sk TEXT NOT NULL,
    address TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS historical_prices (
    currency TEXT NOT NULL,
    timestamp INTEGER NOT NULL,
    price REAL NOT NULL,
    PRIMARY KEY (currency, timestamp));
CREATE TABLE IF NOT EXISTS contacts (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    dirty BOOL NOT NULL);

CREATE INDEX i_received_notes ON received_notes(account);
CREATE INDEX i_account ON accounts(address);
CREATE INDEX i_contact ON contacts(address);
CREATE INDEX i_transaction ON transactions(account);
CREATE INDEX i_witness ON sapling_witnesses(height);

CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY,
    account INTEGER NOT NULL,
    sender TEXT,
    recipient TEXT NOT NULL,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    timestamp INTEGER NOT NULL,
    height INTEGER NOT NULL,
    read BOOL NOT NULL);

INSERT INTO schema_version(id, version) VALUES (1, 3) ON CONFLICT(id) DO NOTHING;
