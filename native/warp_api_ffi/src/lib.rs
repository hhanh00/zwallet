mod api;

#[no_mangle]
pub extern "C" fn get_from_rust() -> i32 {
    api::get_from_rust()
}
