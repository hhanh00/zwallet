#!/bin/sh

sudo pacman -Sy --noconfirm git cmake rustup
rustup install stable
rustup target add aarch64-linux-android armv7-linux-androideabi
cargo install --force cargo-ndk
