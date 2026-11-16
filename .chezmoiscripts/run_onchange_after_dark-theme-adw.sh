#!/bin/bash
set -Eeuo pipefail

SCRIPT_NAME="run_onchange_after_dark-theme-adw.sh"
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

if command -v dnf &> /dev/null; then
    sudo dnf install -y adw-gtk3-theme xsettingsd arc-theme
fi

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"

systemctl --user daemon-reload

echo "=== $(date '+%F %T') RESULT: SUCCESS ($SCRIPT_NAME) ==="
