#!/bin/bash

if command -v dnf &> /dev/null; then
    sudo dnf install -y adw-gtk3-theme xsettingsd arc-theme
fi

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"

systemctl --user daemon-reload
