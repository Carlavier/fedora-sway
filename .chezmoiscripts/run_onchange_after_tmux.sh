#!/bin/bash
set -Eeuo pipefail

SCRIPT_NAME="run_onchange_after_tmux.sh"
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

sudo dnf install tmux -y

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

tmux -f "$HOME/.local/share/chezmoi/dot_tmux.conf" new-session -d -s setup_session

"$HOME/.tmux/plugins/tpm/bin/install_plugins"

tmux kill-session -t setup_session

echo "=== $(date '+%F %T') RESULT: SUCCESS ($SCRIPT_NAME) ==="
