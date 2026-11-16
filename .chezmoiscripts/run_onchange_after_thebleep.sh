#!/usr/bin/env sh

set -eu

if command -v thebleep >/dev/null 2>&1; then
    exit 0
fi

pipx install thebleep
