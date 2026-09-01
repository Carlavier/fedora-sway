#!/bin/bash
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

[ -f "$HOME/.local/bin/waybar-fcitx.sh" ] && chmod +x "$HOME/.local/bin/waybar-fcitx.sh"
