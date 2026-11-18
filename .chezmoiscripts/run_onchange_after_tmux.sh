#!/bin/bash
set -Eeuo pipefail

SCRIPT_NAME="run_onchange_after_tmux.sh"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/chezmoi-scripts"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME%.sh}.log"
CONFIG="$HOME/.local/share/chezmoi/dot_tmux.conf"

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

# Initialize tmux with our config.
# Reuse an existing server instead of creating duplicate sessions.
if tmux info >/dev/null 2>&1; then
    tmux source-file "$CONFIG"
else
    tmux -f "$CONFIG" new-session -d -s setup_session
fi

# Make TPM's plugin directory available to both tmux and the installer.
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$TMUX_PLUGIN_MANAGER_PATH"

# Install configured plugins.
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

echo "=== $(date '+%F %T') RESULT: SUCCESS ($SCRIPT_NAME) ==="

