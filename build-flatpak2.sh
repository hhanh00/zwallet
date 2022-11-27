#!/bin/sh

flatpak-builder --user --install --force-clean build-dir me.hanh.zwallet.Ywallet.yml
flatpak build-export /root/repo build-dir
flatpak build-bundle /root/repo ywallet.flatpak me.hanh.zwallet.Ywallet
