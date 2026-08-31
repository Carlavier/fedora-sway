#!/bin/bash
set -e

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

