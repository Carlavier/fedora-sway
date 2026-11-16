#!/bin/bash
set -Eeuo pipefail

SCRIPT_NAME="run_onchange_after_nvim.sh"
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

# Provider bindings
pip3 install --upgrade --user --force-reinstall pynvim
sudo npm install -g tree-sitter-cli neovim

# Download latest stable Neovim AppImage directly
mkdir -p "$HOME/.local/bin"
curl -LO -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage && mv nvim-linux-x86_64.appimage "$HOME/.local/bin/nvim"

# Headless Plugin & LSP Sync
export PATH="$HOME/.local/bin:$PATH"
NVIM="$HOME/.local/bin/nvim"

# Using -c loads init.lua first, ensuring Lazy and Mason commands exist
$NVIM --headless -c "Lazy! sync" +qa || true
$NVIM --headless -c "Lazy! build telescope-fzf-native.nvim" +qa || true
$NVIM --headless -c "MasonInstall basedpyright clangd emmet-language-server lua-language-server vtsls" +qa || true

echo "=== $(date '+%F %T') RESULT: SUCCESS ($SCRIPT_NAME) ==="
