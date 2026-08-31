#!/bin/bash
set -euo pipefail

sudo dnf install -y \
    @development-tools \
    gcc \
    gcc-c++ \
    make \
    cmake \
    pkgconfig \
    fontconfig-devel \
    freetype-devel \
    libxcb-devel \
    libxkbcommon-devel \
    curl \
    wget \
    git \
    fd-find \
    nodejs \
    npm \
    ripgrep \
    python3-pip \
    luarocks \
    lua \
    lua-devel \
    wl-clipboard \
    cowsay \
    fortune-mod \
    chafa \
    timg

pip3 install autotiling
