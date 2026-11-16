#!/bin/bash
set -Eeuo pipefail

SCRIPT_NAME="run_onchange_after_warp-cli.sh"
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

if ! command -v warp-cli &> /dev/null; then
    curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | sudo tee /etc/yum.repos.d/cloudflare-warp.repo > /dev/null
    sudo dnf check-update || true
    sudo dnf install -y cloudflare-warp
    sudo systemctl enable --now warp-svc
fi

echo "=== $(date '+%F %T') RESULT: SUCCESS ($SCRIPT_NAME) ==="
