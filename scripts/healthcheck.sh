#!/bin/sh

set -eu

ENV_FILE="${LAZYNET_ENV:-/etc/lazynet/lazynet.env}"
if [ -f "$ENV_FILE" ]; then
	. "$ENV_FILE"
fi

LAZYNET_CLIENT_IP="${LAZYNET_CLIENT_IP:-192.168.3.50}"
MIHOMO_DNS_PORT="${MIHOMO_DNS_PORT:-7874}"
MIHOMO_REDIR_PORT="${MIHOMO_REDIR_PORT:-7892}"
MIHOMO_API_URL="${MIHOMO_API_URL:-http://127.0.0.1:9090/version}"
LAZYNET_CHAIN="${LAZYNET_CHAIN:-LAZYNET}"

fail=0

check() {
	name="$1"
	shift
	if "$@" >/dev/null 2>&1; then
		printf '[ok] %s\n' "$name"
	else
		printf '[fail] %s\n' "$name"
		fail=1
	fi
}

if [ -x /etc/init.d/lazynet ]; then
	check "lazynet service" /etc/init.d/lazynet status
elif [ -x /etc/init.d/ps5clash ]; then
	check "ps5clash service" /etc/init.d/ps5clash status
else
	printf '[fail] service script missing\n'
	fail=1
fi
check "mihomo api" curl -fsS --max-time 5 "$MIHOMO_API_URL"
check "client dns redirect" sh -c "iptables -t nat -S PREROUTING 2>/dev/null | grep -q -- '-s $LAZYNET_CLIENT_IP/32 .*--to-ports $MIHOMO_DNS_PORT'"
check "client tcp redirect" sh -c "iptables -t nat -S PREROUTING 2>/dev/null | grep -q -- '-s $LAZYNET_CLIENT_IP/32 .* -j $LAZYNET_CHAIN'"
check "redir chain target" sh -c "iptables -t nat -S $LAZYNET_CHAIN 2>/dev/null | grep -q -- '--to-ports $MIHOMO_REDIR_PORT'"

df -h / /overlay /tmp 2>/dev/null || true

exit "$fail"
