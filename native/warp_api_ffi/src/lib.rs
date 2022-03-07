use allo_isolate::ffi;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;

mod api;

static mut POST_COBJ: Option<ffi::DartPostCObjectFnType> = None;

#[no_mangle]
pub unsafe extern "C" fn init_wallet(db_path: *mut c_char) {
    let db_path = CStr::from_ptr(db_path).to_string_lossy();
    api::init_wallet(&db_path);
}

#[no_mangle]
pub unsafe extern "C" fn reset_app() {
    api::reset_app();
}

#[no_mangle]
pub unsafe extern "C" fn warp_sync(coin: u8, get_tx: bool, anchor_offset: u32, port: i64) -> i8 {
    api::warp_sync(coin, get_tx, anchor_offset, port)
}

#[no_mangle]
pub unsafe extern "C" fn dart_post_cobject(ptr: ffi::DartPostCObjectFnType) {
    POST_COBJ = Some(ptr);
}

#[no_mangle]
pub unsafe extern "C" fn get_latest_height(coin: u8) -> u32 {
    api::get_latest_height(coin)
}

#[no_mangle]
pub unsafe extern "C" fn is_valid_key(coin: u8, seed: *mut c_char) -> i8 {
    let seed = CStr::from_ptr(seed).to_string_lossy();
    api::is_valid_key(coin, &seed)
}

#[no_mangle]
pub unsafe extern "C" fn valid_address(coin: u8, address: *mut c_char) -> bool {
    let address = CStr::from_ptr(address).to_string_lossy();
    api::valid_address(coin, &address)
}

#[no_mangle]
pub unsafe extern "C" fn new_address(coin: u8, account: u32) -> *mut c_char {
    let address = api::new_address(coin, account);
    CString::new(address).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn set_mempool_account(coin: u8, account: u32) {
    api::set_mempool_account(coin, account);
}

#[no_mangle]
pub unsafe extern "C" fn new_account(
    coin: u8,
    name: *mut c_char,
    data: *mut c_char,
    index: u32,
) -> i32 {
    let name = CStr::from_ptr(name).to_string_lossy();
    let data = CStr::from_ptr(data).to_string_lossy();
    api::new_account(coin, &name, &data, index)
}

#[no_mangle]
pub unsafe extern "C" fn new_sub_account(coin: u8, id: u32, name: *mut c_char) -> i32 {
    let name = CStr::from_ptr(name).to_string_lossy();
    api::new_sub_account(coin, id, &name)
}

#[no_mangle]
pub unsafe extern "C" fn get_mempool_balance(coin: u8) -> i64 {
    api::get_mempool_balance(coin)
}

#[no_mangle]
pub unsafe extern "C" fn send_multi_payment(
    coin: u8,
    account: u32,
    recipients_json: *mut c_char,
    anchor_offset: u32,
    use_transparent: bool,
    port: i64,
) -> *const c_char {
    let recipients_json = CStr::from_ptr(recipients_json).to_string_lossy();
    let tx_id = api::send_multi_payment(
        coin,
        account,
        &recipients_json,
        use_transparent,
        anchor_offset,
        port,
    );
    CString::new(tx_id).unwrap().into_raw()
}

// #[no_mangle]
// pub unsafe extern "C" fn try_warp_sync(coin: u8, get_tx: bool, anchor_offset: u32) -> i8 {
//     api::try_warp_sync(coin, get_tx, anchor_offset)
// }

#[no_mangle]
pub unsafe extern "C" fn skip_to_last_height(coin: u8) {
    api::skip_to_last_height(coin)
}

#[no_mangle]
pub unsafe extern "C" fn rewind_to_height(coin: u8, height: u32) {
    api::rewind_to_height(coin, height)
}

#[no_mangle]
pub unsafe extern "C" fn mempool_sync(coin: u8) -> i64 {
    api::mempool_sync(coin)
}

#[no_mangle]
pub unsafe extern "C" fn mempool_reset(coin: u8, height: u32) {
    api::mempool_reset(coin, height)
}

#[no_mangle]
pub unsafe extern "C" fn get_taddr_balance(coin: u8, account: u32) -> u64 {
    api::get_taddr_balance(coin, account)
}

#[no_mangle]
pub unsafe extern "C" fn shield_taddr(coin: u8, account: u32) -> *mut c_char {
    let tx_id = api::shield_taddr(coin, account);
    CString::new(tx_id).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn set_lwd_url(coin: u8, url: *mut c_char) {
    let url = CStr::from_ptr(url).to_string_lossy();
    api::set_lwd_url(coin, &url);
}

#[no_mangle]
pub unsafe extern "C" fn prepare_multi_payment(
    coin: u8,
    account: u32,
    recipients_json: *mut c_char,
    use_transparent: bool,
    anchor_offset: u32,
) -> *mut c_char {
    let recipients_json = CStr::from_ptr(recipients_json).to_string_lossy();
    let tx = api::prepare_multi_payment(
        coin,
        account,
        &recipients_json,
        use_transparent,
        anchor_offset,
    );
    CString::new(tx).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn broadcast(coin: u8, tx_filename: *mut c_char) -> *mut c_char {
    let tx_filename = CStr::from_ptr(tx_filename).to_string_lossy();
    let res = api::broadcast(coin, &tx_filename);
    CString::new(res).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn broadcast_txhex(coin: u8, txhex: *mut c_char) -> *mut c_char {
    let txhex = CStr::from_ptr(txhex).to_string_lossy();
    let res = api::broadcast_txhex(coin, &txhex);
    CString::new(res).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn sync_historical_prices(
    coin: u8,
    now: i64,
    days: u32,
    currency: *mut c_char,
) -> u32 {
    let currency = CStr::from_ptr(currency).to_string_lossy();
    api::sync_historical_prices(coin, now, days, &currency)
}

#[no_mangle]
pub unsafe extern "C" fn get_ua(
    sapling_addr: *mut c_char,
    transparent_addr: *mut c_char,
) -> *mut c_char {
    let sapling_addr = CStr::from_ptr(sapling_addr).to_string_lossy();
    let transparent_addr = CStr::from_ptr(transparent_addr).to_string_lossy();
    let ua_addr = api::get_ua(&sapling_addr, &transparent_addr);
    CString::new(ua_addr).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn get_sapling(ua_addr: *mut c_char) -> *mut c_char {
    let ua_addr = CStr::from_ptr(ua_addr).to_string_lossy();
    let sapling_addr = api::get_sapling(&ua_addr);
    CString::new(sapling_addr).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn store_contact(
    coin: u8,
    id: u32,
    name: *mut c_char,
    address: *mut c_char,
    dirty: bool,
) {
    let name = CStr::from_ptr(name).to_string_lossy();
    let address = CStr::from_ptr(address).to_string_lossy();
    api::store_contact(coin, id, &name, &address, dirty);
}

#[no_mangle]
pub unsafe extern "C" fn commit_unsaved_contacts(
    coin: u8,
    account: u32,
    anchor_offset: u32,
) -> *mut c_char {
    let tx_id = api::commit_unsaved_contacts(coin, account, anchor_offset);
    CString::new(tx_id).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn delete_account(coin: u8, account: u32) {
    api::delete_account(coin, account);
}

#[no_mangle]
pub unsafe extern "C" fn truncate_data(coin: u8) {
    api::truncate_data(coin);
}

#[no_mangle]
pub unsafe extern "C" fn make_payment_uri(
    coin: u8,
    address: *mut c_char,
    amount: u64,
    memo: *mut c_char,
) -> *mut c_char {
    let address = CStr::from_ptr(address).to_string_lossy();
    let memo = CStr::from_ptr(memo).to_string_lossy();
    let uri = api::make_payment_uri(coin, &address, amount, &memo);
    CString::new(uri).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn parse_payment_uri(coin: u8, uri: *mut c_char) -> *mut c_char {
    let uri = CStr::from_ptr(uri).to_string_lossy();
    let payment_json = api::parse_payment_uri(coin, &uri);
    CString::new(payment_json).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn generate_random_enc_key() -> *mut c_char {
    let key = api::generate_random_enc_key();
    CString::new(key).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn get_full_backup(key: *mut c_char) -> *mut c_char {
    let key = CStr::from_ptr(key).to_string_lossy();
    let backup = api::get_full_backup(&key);
    CString::new(backup).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn restore_full_backup(key: *mut c_char, backup: *mut c_char) -> *mut c_char {
    let key = CStr::from_ptr(key).to_string_lossy();
    let backup = CStr::from_ptr(backup).to_string_lossy();
    let res = api::restore_full_backup(&key, &backup);
    CString::new(res).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn store_share_secret(coin: u8, account: u32, secret: *mut c_char) {
    let secret = CStr::from_ptr(secret).to_string_lossy();
    api::store_share_secret(coin, account, &secret);
}

#[no_mangle]
pub unsafe extern "C" fn get_share_secret(coin: u8, account: u32) -> *mut c_char {
    let secret = api::get_share_secret(coin, account);
    CString::new(secret).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn run_aggregator(secret_share: *mut c_char, port: u16, send_port: i64) {
    let secret_share = CStr::from_ptr(secret_share).to_string_lossy();
    api::run_aggregator(&secret_share, port, send_port);
}

#[no_mangle]
pub unsafe extern "C" fn shutdown_aggregator() {
    api::shutdown_aggregator();
}

#[no_mangle]
pub unsafe extern "C" fn submit_multisig_tx(tx_json: *mut c_char, port: u16) -> *mut c_char {
    let tx_json = CStr::from_ptr(tx_json).to_string_lossy();
    let raw_tx = api::submit_multisig_tx(&tx_json, port);
    let raw_tx = hex::encode(raw_tx);
    CString::new(raw_tx).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn run_multi_signer(
    address: *mut c_char,
    amount: u64,
    secret_share: *mut c_char,
    aggregator_url: *mut c_char,
    my_url: *mut c_char,
    port: u16,
) -> u32 {
    let address = CStr::from_ptr(address).to_string_lossy();
    let secret_share = CStr::from_ptr(secret_share).to_string_lossy();
    let aggregator_url = CStr::from_ptr(aggregator_url).to_string_lossy();
    let my_url = CStr::from_ptr(my_url).to_string_lossy();
    api::run_multi_signer(
        &address,
        amount,
        &secret_share,
        &aggregator_url,
        &my_url,
        port,
    )
}

#[no_mangle]
pub unsafe extern "C" fn split_account(
    coin: u8,
    threshold: u32,
    participants: u32,
    account: u32,
) -> *mut c_char {
    let r = api::split_account(coin, threshold, participants, account);
    CString::new(r).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn dummy_export() {}
