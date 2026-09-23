#!/usr/bin/env bash

set -euo pipefail

mode="$1"
shift

chmod "${mode}x" "$@"
