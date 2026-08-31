#!/bin/bash
set -euo pipefail

sudo apt update && sudo apt install -y \
    cmake g++ pkg-config libfontconfig1-dev libfreetype6-dev \
    libxcb-xfixes0-dev libxkbcommon-dev libxcb-cursor-dev python3 curl wget

SRC_DIR="$HOME/.local/src"
mkdir -p "$SRC_DIR"
cd "$SRC_DIR"

if [ -d "alacritty" ]; then
    cd alacritty
    git fetch --depth 1
    git reset --hard origin/master
else
    git clone --depth 1 https://github.com/alacritty/alacritty.git
    cd alacritty
fi

if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source "$HOME/.cargo/env"
rustup override set stable
rustup update stable

cargo build --release
mkdir -p "$HOME/.local/bin"
cp target/release/alacritty "$HOME/.local/bin/"

CMD="$HOME/.local/bin/alacritty"
KEY="<Primary><Alt>t"
PATH_ID="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom_alacritty/"
SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH_ID"

gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "[]"
gsettings set "$SCHEMA" name 'Alacritty'
gsettings set "$SCHEMA" command "$CMD"
gsettings set "$SCHEMA" binding "$KEY"

CURRENT=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
if [[ "$CURRENT" != *"$PATH_ID"* ]]; then
    if [[ "$CURRENT" == "@as []" || "$CURRENT" == "[]" || -z "$CURRENT" ]]; then
        NEW_LIST="['$PATH_ID']"
    else
        NEW_LIST=$(echo "$CURRENT" | sed "s|\]|, '$PATH_ID'\]|")
    fi
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_LIST"
fi

ICON_PATH="$HOME/.local/share/icons/alacritty.svg"
DESKTOP_FILE="$HOME/.local/share/applications/alacritty.desktop"

mkdir -p "$HOME/.local/share/icons" "$HOME/.local/share/applications"
wget -O "$ICON_PATH" "https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/alacritty-term.svg"

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

update-desktop-database "$HOME/.local/share/applications"
