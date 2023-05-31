set -x
cargo b -r --target=x86_64-apple-darwin --features=dart_ffi,sqlcipher,ledger
cd target/x86_64-apple-darwin/release
rm -rf build examples deps incremental .fingerprint *.rlib
