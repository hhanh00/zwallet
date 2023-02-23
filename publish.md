# How to publish new versions to the App Stores

The target audience for this doc are the maintainers (currently just me).

Thankfully, most of the work is automated by Github CI and build scripts. 
They drop several artifacts for each release. To produce a new release,
tag a commit with `v*`, i.e. `v2.0.0+1000` following the `pubspec.yaml`
version format with a prefix `v`.

You should have these files:
- app-fdroid.aab
- app-fdroid.apk
- libwarp_api_ffi.so
- Ywallet-latest-x86_64.AppImage
- ywallet-universal.dmg
- ywallet.flatpak
- YWallet.msix
- ywallet.zip
- zwallet.tgz

## Android
The android package `app-fdroid.aab` is auto-published as an Internal Release. Just test it and promote to Production.

`app-fdroid.apk` is a standalone installation package for users who don't have access to the Google Play Store.

## IOS
iOS build has to be made manually.

```
cd ywallet
./codegen.sh
flutter build ipa
```

Then use the `Transporter` app to upload the `YWallet.ipa` to the store. Wait 5 mn for its processing and then test.
If OK, submit a new release

## MacOS
`ywallet-universal.dmg` is a universal DMG that can be installed on Intel and Apple chip macs.

## Linux
`Ywallet-latest-x86_64.AppImage` is an appimage. Make it executable and then run.
`ywallet.flatpak` is a flatpak. Install it `flatpak install ywallet.flatpak` and then run.

To update the Flathub version:
- Go to the `misc/flathub` dir,
- Edit `app.ywallet.Ywallet.yml` and change the path to `libwarp_api_ffi.so` and `zwallet.tgz`
- Edit the SHA256 checksum. It can be calculated using `shasum -a 256` (the files must be downloaded first)
- Edit the build version and date/time
- Create a branch
- Push and then open a PR
- Check that flathub bot builds correctly
- Then merge/squash
- Flathub should build and publish the new version automatically

## Windows
Upload `YWallet.msix` to the Microsoft Developer Portal. Submit an update to YWallet.
- Remove the old msix
- Save
- Add the new msix
- Save
- Submit

`ywallet.zip` is a portable version that doesn't require installation.
