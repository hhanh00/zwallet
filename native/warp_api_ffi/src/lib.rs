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
pub unsafe extern "C" fn warp_sync(port: i64) {
    api::warp_sync(port);
}

#[no_mangle]
pub unsafe extern "C" fn dart_post_cobject(ptr: ffi::DartPostCObjectFnType) {
    POST_COBJ = Some(ptr);
}

#[no_mangle]
pub unsafe extern "C" fn get_latest_height() -> u32 {
    api::get_latest_height()
}

#[no_mangle]
pub unsafe extern "C" fn is_valid_key(seed: *mut c_char) -> bool {
    let seed = CStr::from_ptr(seed).to_string_lossy();
    sync::is_valid_key(&seed)
}

#[no_mangle]
pub unsafe extern "C" fn valid_address(address: *mut c_char) -> bool {
    let address = CStr::from_ptr(address).to_string_lossy();
    api::valid_address(&address)
}

#[no_mangle]
pub unsafe extern "C" fn set_mempool_account(account: u32) {
    api::set_mempool_account(account);
}

#[no_mangle]
pub unsafe extern "C" fn new_account(name: *mut c_char, data: *mut c_char) -> u32 {
    let name = CStr::from_ptr(name).to_string_lossy();
    let data = CStr::from_ptr(data).to_string_lossy();
    api::new_account(&name, &data)
}

#[no_mangle]
pub unsafe extern "C" fn get_mempool_balance() -> i64 {
    api::get_mempool_balance()
}

#[no_mangle]
pub unsafe extern "C" fn send_payment(
    account: u32,
    address: *mut c_char,
    amount: u64,
) -> *const c_char {
    let address = CStr::from_ptr(address).to_string_lossy();
    let tx_id = api::send_payment(account, &address, amount);
    CString::new(tx_id).unwrap().into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn try_warp_sync() -> i8 {
    api::try_warp_sync()
}

#[no_mangle]
pub unsafe extern "C" fn skip_to_last_height() {
    api::skip_to_last_height()
}

#[no_mangle]
pub unsafe extern "C" fn rewind_to_height(height: u32) {
    api::rewind_to_height(height)
}

#[no_mangle]
pub unsafe extern "C" fn mempool_sync() -> i64 {
    api::mempool_sync()
}
