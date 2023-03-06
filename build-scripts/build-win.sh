echo $1

# Download params
mkdir /d/.zcash-params
curl https://download.z.cash/downloads/sapling-output.params --output /d/.zcash-params/sapling-output.params
curl https://download.z.cash/downloads/sapling-spend.params --output /d/.zcash-params/sapling-spend.params
export HOME=/d/

git clone -b $1 --depth 1 https://github.com/flutter/flutter.git /d/flutter
export PATH=$PATH:/d/flutter/bin

flutter doctor -v

# DLL
sed -e 's/rlib/cdylib/' < native/zcash-sync/Cargo.toml >/tmp/out.toml
mv /tmp/out.toml native/zcash-sync/Cargo.toml
cargo b -r --features=dart_ffi,sqlcipher

# Codegen
flutter pub get
flutter pub run build_runner build -d
pushd packages/warp_api_ffi
flutter pub get
flutter pub run build_runner build -d
popd

# Build flutter
flutter build windows
cp runtime/* build/windows/runner/release
cp target/release/warp_api_ffi.dll build/windows/runner/release
flutter pub run msix:create
mv build/windows/runner/Release/YWallet.msix .

flutter build windows
cp runtime/* build/windows/runner/Release
pushd build/windows/runner
mv Release ywallet
7z a ../../../ywallet.zip ywallet
popd
