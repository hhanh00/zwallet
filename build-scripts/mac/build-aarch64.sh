set -x
rustup target add aarch64-apple-darwin
cargo b -r --target=aarch64-apple-darwin --features=dart_ffi,sqlcipher,ledger
cd target/aarch64-apple-darwin/release
rm -rf build examples deps incremental .fingerprint *.rlib
