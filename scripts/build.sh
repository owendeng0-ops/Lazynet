#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

"$REPO_ROOT/scripts/generate-manifest.sh"
"$REPO_ROOT/scripts/generate-mihomo.sh"
"$REPO_ROOT/scripts/generate-shadowrocket.sh"
"$REPO_ROOT/scripts/generate-verge.sh"

printf 'LazyNet build complete.\n'

