#!/bin/bash
set -euo pipefail

mkdir -p "$HOME/.local/src"
cd "$HOME/.local/src"
rm -rf alacritty
git clone --depth 1 https://github.com/alacritty/alacritty.git
cd alacritty

if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source "$HOME/.cargo/env"
rustup override set stable
rustup update stable

cargo build --release
mkdir -p "$HOME/.local/bin"
cp target/release/alacritty "$HOME/.local/bin/"

ICON_PATH="$HOME/.local/share/icons/alacritty.svg"
DESKTOP_FILE="$HOME/.local/share/applications/alacritty.desktop"

mkdir -p "$HOME/.local/share/icons"
mkdir -p "$HOME/.local/share/applications"

if [ ! -f "$ICON_PATH" ]; then
    wget -O "$ICON_PATH" "https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/alacritty-term.svg"
fi

if [ ! -f "$DESKTOP_FILE" ]; then
cat <<EOF >"$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Exec=$HOME/.local/bin/alacritty
Icon=$ICON_PATH
Name=Alacritty
Comment=GPU accelerated terminal
Terminal=false
Categories=System;TerminalEmulator;
EOF
fi

update-desktop-database "$HOME/.local/share/applications"

FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
    TMP_ZIP=$(mktemp --suffix=.zip)
    trap 'rm -f "$TMP_ZIP"' EXIT
    wget -O "$TMP_ZIP" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o "$TMP_ZIP" -d "$FONT_DIR"
    fc-cache -fv
fi
