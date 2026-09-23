#!/bin/sh

case "$1" in
    *.tar*) tar tf "$1" ;;
    *.zip) unzip -l "$1" ;;
    *.rar) unrar l "$1" ;;
    *.7z) 7z l "$1" ;;
    *.pdf) pdftotext "$1" - ;;
    *.png|*.jpg|*.jpeg|*.webp|*.gif|*.bmp|*.svg)
        chafa --size="${2}x${3}" "$1"
        ;;
    *lfrc) bat -p --color=always -l vim "$1" ;;
    *) bat -p --color=always "$1" ;;
esac
EOF
