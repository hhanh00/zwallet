FLUTTER_VERSION=$1
HOME=$2

mkdir -p $HOME/.zcash-params
curl https://download.z.cash/downloads/sapling-output.params --output $HOME/.zcash-params/sapling-output.params
curl https://download.z.cash/downloads/sapling-spend.params --output $HOME/.zcash-params/sapling-spend.params

git clone -b "$FLUTTER_VERSION" --depth 1 https://github.com/flutter/flutter.git flutter
flutter doctor -v

cargo install cargo-make
cargo make flatpak

sudo apt-get install -y libunwind-dev
sudo apt-get install -y clang cmake ninja-build libgtk-3-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libsecret-1-dev libjsoncpp-dev

flutter pub get
flutter pub run build_runner build
(cd packages/warp_api_ffi;flutter pub get;flutter pub run build_runner build)
flutter build linux
