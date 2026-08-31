#!/bin/bash
set -e

sudo dnf install -y \
    @development-tools \
    gcc \
    gcc-c++ \
    make \
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
