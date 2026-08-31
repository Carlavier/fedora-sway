#!/bin/bash
set -euo pipefail

BASHRC="$HOME/.bashrc"
CUSTOM_FILE="$HOME/.bashrc-custom"
BLOCK='# Source custom bash settings if file exists
if [ -f "$HOME/.bashrc-custom" ]; then
    . "$HOME/.bashrc-custom"
fi'

if ! grep -qF '$HOME/.bashrc-custom' "$BASHRC" 2>/dev/null; then
    echo -e "\n$BLOCK" >> "$BASHRC"
    echo "Added custom source block to $BASHRC"
else
    echo "Custom source block already exists in $BASHRC"
fi
