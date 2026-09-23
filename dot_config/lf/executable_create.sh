#!/usr/bin/env bash

path="$1"

[ -z "$path" ] && exit 0

case "$path" in
    */)
        mkdir -p "$path"
        ;;
    *)
        mkdir -p "$(dirname "$path")"
        touch "$path"
        ;;
esac
