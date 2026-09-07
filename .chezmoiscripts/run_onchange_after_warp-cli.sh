#!/bin/bash

set -euo pipefail

if ! command -v warp-cli &> /dev/null; then
    curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | sudo tee /etc/yum.repos.d/cloudflare-warp.repo > /dev/null
    sudo dnf check-update || true
    sudo dnf install -y cloudflare-warp
    sudo systemctl enable --now warp-svc
fi
