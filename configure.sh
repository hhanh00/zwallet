export COIN=$1

case $COIN in
ycash)
  export APP_TITLE=YWallet
  export APP_NAME=ywallet
  ;;
zcashtest)
  export APP_TITLE=ZWalletTest
  export APP_NAME=zwallettest
  ;;
zcash)
  export APP_TITLE=WarpWallet
  export APP_NAME=warpwallet
  ;;
esac

cp assets/$COIN.png assets/icon.png
cp lib/coin/$COIN.dart lib/coin/coindef.dart
cp native/zcash-sync/src/coindef/$COIN.rs native/zcash-sync/src/coin.rs

mo pubspec.yaml.tpl > pubspec.yaml

flutter pub get
flutter pub run change_app_package_name:main me.hanh.$APP_NAME
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_app_name
flutter pub run build_runner build
flutter pub run flutter_native_splash:create
