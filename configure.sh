export COIN=$1

case $COIN in
ycash)
  export APP_TITLE=YWallet
  export APP_NAME=ywallet
  ;;
ycashtest)
  export APP_TITLE=YWalletTest
  export APP_NAME=ywallettest
  ;;
zcashtest)
  export APP_TITLE=ZWalletTest
  export APP_NAME=zwallettest
  ;;
zcash)
  export APP_TITLE=ZWallet
  export APP_NAME=zwallet
  ;;
esac

cp assets/$COIN.png assets/icon.png
cp lib/coin/$COIN.dart lib/coin/coindef.dart
cp native/zcash-params/src/coindef/$COIN.rs native/zcash-params/src/coin.rs

mo pubspec.yaml.tpl > pubspec.yaml
mo android/app/src/main/AndroidManifest.xml.tpl > android/app/src/main/AndroidManifest.xml

flutter pub get
flutter pub run change_app_package_name:main me.hanh.$APP_NAME
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_app_name
flutter pub run build_runner build
flutter pub run flutter_native_splash:create

(cd packages/warp_api_ffi; flutter pub get; flutter pub run build_runner build)

