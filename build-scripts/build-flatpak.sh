#!/bin/sh

docker rm zwallet_flatpak_sh
docker rm zwallet_flatpak_bin
docker build -f docker/Dockerfile-flatpak -t zwallet_flatpak_sh --build-arg FLUTTER_VERSION=$1 .
docker run --privileged --name zwallet_flatpak_bin zwallet_flatpak_sh
docker cp zwallet_flatpak_bin:/root/misc/ywallet.flatpak .
docker cp zwallet_flatpak_bin:/root/misc/root/zwallet.tgz .
docker cp zwallet_flatpak_bin:/root/misc/root/libwarp_api_ffi.so .
