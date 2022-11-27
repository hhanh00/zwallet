#!/bin/sh

docker rm zwallet_flatpak_sh
docker rm zwallet_flatpak_bin
docker build -f docker/Dockerfile-flatpak -t zwallet_flatpak_sh .
docker run --privileged --name zwallet_flatpak_bin zwallet_flatpak_sh
docker cp zwallet_flatpak_bin:/root/misc/ywallet.flatpak .
