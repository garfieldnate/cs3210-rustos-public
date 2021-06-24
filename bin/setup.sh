#!/bin/bash

set -e

TOP=$(git rev-parse --show-toplevel)
BIN=$TOP/bin
DEP=$TOP/.dep
VER=nightly-2021-06-23
PROJ_PKG=(build-essential
     python3
     socat
     wget
     curl
     tar
     screen
     clang-13
     lld-11
     linux-image-extra-virtual)
QEMU_DEP=(libglib2.0-dev libpixman-1-dev zlib1g-dev)

# install pkgs
if [[ $($BIN/get-dist) == "ubuntu" ]]; then
    echo "[!] Installing packages"

    sudo apt update
    sudo apt install -y ${PROJ_PKG[*]}
    sudo apt install -y ${QEMU_DEP[*]}
fi

# install rustup
if ! [ -x "$(command -v rustup)" ]; then
    echo "[!] Installing rustup"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    export PATH=$HOME/.cargo/bin:$PATH
fi

rustup default $VER
rustup component add rust-src llvm-tools-preview clippy

if ! [ -e cargo-objcopy ]; then
  cargo install cargo-binutils --locked
fi

echo "[!] Please ensure '$HOME/.cargo/bin' is on your PATH"
