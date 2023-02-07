#!/bin/sh

adb uninstall me.hanh.ywallet
bundletool build-apks --overwrite --bundle=build/app/outputs/bundle/release/app-release.aab --output=/tmp/app.apks --ks=docker/zwallet.jks --ks-key-alias=zwallet --ks-pass=pass:$JKS_PASSWORD
bundletool install-apks --adb=$ANDROID_SDK_ROOT/platform-tools/adb --apks=/tmp/app.apks
