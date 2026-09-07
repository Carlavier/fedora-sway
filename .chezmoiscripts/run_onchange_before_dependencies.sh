#!/bin/bash
set -euo pipefail

sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

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
    mesa-va-drivers-freeworld \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly \
    curl \
    wget \
    git \
    fd-find \
    nodejs \
    npm \
    ripgrep \
    python3-pip \
    pipx \
    luarocks \
    lua \
    lua-devel \
    wl-clipboard \
    cowsay \
    fortune-mod \
    chafa \
    timg \
    ibus \
    python3-i3ipc \
    wf-recorder

pipx install autotiling
