#!/bin/bash

sudo dnf install tmux -y

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

tmux -f "$HOME/.local/share/chezmoi/dot_tmux.conf" new-session -d -s setup_session

"$HOME/.tmux/plugins/tpm/bin/install_plugins"

tmux kill-session -t setup_session
