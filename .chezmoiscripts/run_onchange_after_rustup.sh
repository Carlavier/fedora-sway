#!/bin/bash

if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

rustup default stable
rustup component add rust-analyzer
