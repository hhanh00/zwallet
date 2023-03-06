pushd $HOME
mkdir .zcash-params
curl https://download.z.cash/downloads/sapling-output.params --output .zcash-params/sapling-output.params
curl https://download.z.cash/downloads/sapling-spend.params --output .zcash-params/sapling-spend.params

rustup target add aarch64-apple-darwin
popd

git clone -b "$1" --depth 1 https://github.com/flutter/flutter.git flutter
flutter doctor -v

sed -e 's/rlib/cdylib/' < native/zcash-sync/Cargo.toml >/tmp/out.toml
mv /tmp/out.toml native/zcash-sync/Cargo.toml

cargo b -r --target=x86_64-apple-darwin --features=dart_ffi,sqlcipher
cargo b -r --target=aarch64-apple-darwin --features=dart_ffi,sqlcipher

mkdir -p target/universal/release
lipo target/x86_64-apple-darwin/release/libwarp_api_ffi.dylib target/aarch64-apple-darwin/release/libwarp_api_ffi.dylib -output target/universal/release/libwarp_api_ffi.dylib -create
cp native/zcash-sync/binding.h packages/warp_api_ffi/ios/Classes/binding.h

./configure.sh
flutter build macos

npm install -g appdmg
pushd misc
appdmg app.json ../ywallet-universal.dmg
popd
