#!/bin/bash
set -Eeuo pipefail

SCRIPT_NAME="run_onchange_before_dependencies.sh"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/chezmoi-scripts"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME%.sh}.log"
mkdir -p "$LOG_DIR"

exec > >(tee "$LOG_FILE") 2>&1

on_error() {
    local exit_code=$?
    echo ""
    echo "=== RESULT: ERROR ($SCRIPT_NAME) ==="
    echo "exit code: $exit_code"
    echo "line: $1"
    echo "command: $BASH_COMMAND"
    echo "log: $LOG_FILE"
    exit "$exit_code"
}
trap 'on_error $LINENO' ERR

echo "=== $(date '+%F %T') START $SCRIPT_NAME ==="

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

echo "=== $(date '+%F %T') RESULT: SUCCESS ($SCRIPT_NAME) ==="
