#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn create_election(urls: String, key: String) -> String {
    urls.clone()
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
