#!/bin/sh

set -eu

ENV_FILE="${LAZYNET_ENV:-/etc/lazynet/lazynet.env}"
if [ -f "$ENV_FILE" ]; then
	. "$ENV_FILE"
fi

MIHOMO_API_BASE="${MIHOMO_API_BASE:-http://127.0.0.1:9090}"
MIHOMO_MIXED_PORT="${MIHOMO_MIXED_PORT:-7890}"
MIHOMO_MONITOR_GROUP_ENCODED="${MIHOMO_MONITOR_GROUP_ENCODED:-Proxy}"
PROXY_URL="${PROXY_URL:-http://127.0.0.1:$MIHOMO_MIXED_PORT}"

json_escape() {
	sed 's/\\/\\\\/g; s/"/\\"/g'
}

current_node() {
	curl -fsS --max-time 5 "$MIHOMO_API_BASE/proxies/$MIHOMO_MONITOR_GROUP_ENCODED" 2>/dev/null |
		sed -n 's/.*"now":"\([^"]*\)".*/\1/p' |
		sed -n '1p'
}

probe_url() {
	name="$1"
	url="$2"
	raw=$(curl -x "$PROXY_URL" -o /dev/null -sS -w 'http=%{http_code} connect=%{http_connect} time=%{time_total}' --connect-timeout 8 --max-time 25 "$url" 2>/dev/null || true)
	case "$raw" in
		*"connect=200"*)
			state="ok"
			;;
		*)
			state="fail"
			;;
	esac
	printf '{"name":"%s","state":"%s","result":"%s"}' \
		"$(printf '%s' "$name" | json_escape)" \
		"$state" \
		"$(printf '%s' "$raw" | json_escape)"
}

json_field() {
	key="$1"
	sed -n "s/.*\"$key\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p" |
		sed -n '1p'
}

exit_geo() {
	raw=$(curl -x "$PROXY_URL" -fsS --connect-timeout 8 --max-time 20 https://ipinfo.io/json 2>/dev/null || true)
	ip=$(printf '%s' "$raw" | json_field "ip")
	city=$(printf '%s' "$raw" | json_field "city")
	region=$(printf '%s' "$raw" | json_field "region")
	country=$(printf '%s' "$raw" | json_field "country")
	org=$(printf '%s' "$raw" | json_field "org")

	printf '{"ip":"%s","city":"%s","region":"%s","country":"%s","org":"%s"}' \
		"$(printf '%s' "$ip" | json_escape)" \
		"$(printf '%s' "$city" | json_escape)" \
		"$(printf '%s' "$region" | json_escape)" \
		"$(printf '%s' "$country" | json_escape)" \
		"$(printf '%s' "$org" | json_escape)"
}

node=$(current_node)
[ -n "$node" ] || node="unknown"
updated=$(date '+%Y-%m-%dT%H:%M:%S%z')

printf '{\n'
printf '  "group": "%s",\n' "$(printf '%s' "$MIHOMO_MONITOR_GROUP_ENCODED" | json_escape)"
printf '  "current": "%s",\n' "$(printf '%s' "$node" | json_escape)"
printf '  "updatedAt": "%s",\n' "$updated"
printf '  "exit": '
exit_geo
printf ',\n'
printf '  "checks": [\n'
printf '    '; probe_url "GitHub" "https://github.com"; printf ',\n'
printf '    '; probe_url "Netflix" "https://www.netflix.com"; printf ',\n'
printf '    '; probe_url "ChatGPT" "https://chatgpt.com"; printf '\n'
printf '  ]\n'
printf '}\n'
