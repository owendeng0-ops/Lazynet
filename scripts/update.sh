#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

ENV_FILE="${LAZYNET_ENV:-/etc/lazynet/lazynet.env}"
if [ -f "$ENV_FILE" ]; then
	. "$ENV_FILE"
fi

MIHOMO_CORE="${MIHOMO_CORE:-/tmp/ps5clash/mihomo}"
MIHOMO_OUTPUT="${MIHOMO_OUTPUT:-/tmp/lazynet/mihomo.yaml}"

MIHOMO_OUTPUT="$MIHOMO_OUTPUT" "$REPO_ROOT/scripts/generate-mihomo.sh"

if [ -x "$MIHOMO_CORE" ]; then
	"$MIHOMO_CORE" -t -d "$(dirname "$MIHOMO_OUTPUT")" -f "$MIHOMO_OUTPUT"
else
	echo "mihomo core not found at $MIHOMO_CORE; skipped validation"
fi

if [ -x /etc/init.d/lazynet ]; then
	/etc/init.d/lazynet restart
elif [ -x /etc/init.d/ps5clash ]; then
	/etc/init.d/ps5clash restart
fi
