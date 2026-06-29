#!/bin/sh

set -eu

ENV_FILE="${LAZYNET_ENV:-/etc/lazynet/lazynet.env}"
if [ -f "$ENV_FILE" ]; then
	. "$ENV_FILE"
fi

MIHOMO_MIXED_PORT="${MIHOMO_MIXED_PORT:-7890}"
PROXY_URL="${PROXY_URL:-http://127.0.0.1:$MIHOMO_MIXED_PORT}"

for url in \
	https://www.netflix.com/title/80018499 \
	https://github.com \
	https://chatgpt.com
do
	printf '%s ' "$url"
	curl -x "$PROXY_URL" -o /dev/null -sS -w 'http=%{http_code} time=%{time_total}s\n' --max-time 15 "$url" || true
done

