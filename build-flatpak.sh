#!/bin/sh

rm -rf ~/repo
docker rm zwallet_linux
rm -rf misc/root

docker build --no-cache -f docker/Dockerfile-linux -t zwallet_linux .
docker run --name zwallet_linux zwallet_linux
cd misc
docker cp zwallet_linux:/root .
flatpak-builder --user --install --force-clean build-dir me.hanh.zwallet.Ywallet.yml 
flatpak build-export ~/repo build-dir
flatpak build-bundle ~/repo ywallet.flatpak me.hanh.zwallet.Ywallet
