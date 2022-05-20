#!/bin/sh

pacman -Sy --noconfirm git cmake rustup
rustup install stable
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android
cargo install --force cargo-make cargo-ndk
