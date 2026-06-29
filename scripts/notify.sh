#!/bin/sh

set -eu

ENV_FILE="${LAZYNET_ENV:-/etc/lazynet/lazynet.env}"
if [ -f "$ENV_FILE" ]; then
	. "$ENV_FILE"
fi

message="${1:-LazyNet notification}"

if [ -z "${LAZYNET_NOTIFY_WEBHOOK:-}" ]; then
	echo "$message"
	exit 0
fi

curl -fsS \
	-H 'Content-Type: application/json' \
	-d "{\"text\":\"$message\"}" \
	"$LAZYNET_NOTIFY_WEBHOOK"

