#!/bin/bash
set -Eeuo pipefail

SCRIPT_NAME="run_onchange_after_bashrc-custom.sh"
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

echo "=== $(date '+%F %T') RESULT: SUCCESS ($SCRIPT_NAME) ==="
