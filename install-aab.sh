#!/bin/sh

adb uninstall me.hanh.ywallet
bundletool build-apks --overwrite --bundle=build/app/outputs/bundle/release/app-release.aab --output=/tmp/app.apks --ks=docker/zwallet.jks --ks-key-alias=hanh --ks-pass=pass:$JKS_PASSWORD
bundletool install-apks --adb=/usr/bin/adb --apks=/tmp/app.apks
