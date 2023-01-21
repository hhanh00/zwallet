sed -e 's/rlib/cdylib/' < native/zcash-sync/Cargo.toml >/tmp/out.toml
mv /tmp/out.toml native/zcash-sync/Cargo.toml
cargo ndk --target arm64-v8a build --release --features=dart_ffi
mkdir -p ./packages/warp_api_ffi/android/src/main/jniLibs/arm64-v8a
cp ./target/aarch64-linux-android/release/libwarp_api_ffi.so ./packages/warp_api_ffi/android/src/main/jniLibs/arm64-v8a/
cargo ndk --target armeabi-v7a build --release --features=dart_ffi
mkdir -p ./packages/warp_api_ffi/android/src/main/jniLibs/armeabi-v7a
cp ./target/armv7-linux-androideabi/release/libwarp_api_ffi.so ./packages/warp_api_ffi/android/src/main/jniLibs/armeabi-v7a/
flutter build apk
