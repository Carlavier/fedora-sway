#!/bin/bash
set -Eeuo pipefail

SCRIPT_NAME="run_onchange_after_fcitx5.sh"
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

sudo dnf install -y fcitx5 fcitx5-unikey
mkdir -p "$HOME/.local/share/fcitx5/addon"

cat << 'EOF' > "$HOME/.local/share/fcitx5/addon/notificationitem.conf"
[Addon]
Name=Status Notifier
Type=SharedLibrary
OnDemand=False
Configurable=False
Enabled=False
EOF

if [ -f "$HOME/.local/bin/waybar-fcitx.sh" ]; then
    chmod +x "$HOME/.local/bin/waybar-fcitx.sh"
fi

echo "=== $(date '+%F %T') RESULT: SUCCESS ($SCRIPT_NAME) ==="
