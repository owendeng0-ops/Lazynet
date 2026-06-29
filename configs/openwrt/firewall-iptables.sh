#!/bin/sh

set -eu

ENV_FILE="${LAZYNET_ENV:-/etc/lazynet/lazynet.env}"
if [ -f "$ENV_FILE" ]; then
	. "$ENV_FILE"
fi

LAN_IF="${LAZYNET_LAN_IF:-br-lan}"
CLIENT_IP="${LAZYNET_CLIENT_IP:-192.168.3.50}"
REDIR_PORT="${MIHOMO_REDIR_PORT:-7892}"
DNS_PORT="${MIHOMO_DNS_PORT:-7874}"
CHAIN="${LAZYNET_CHAIN:-LAZYNET}"

delete_rules() {
	iptables -t nat -D PREROUTING -i "$LAN_IF" -s "$CLIENT_IP/32" -p tcp -j "$CHAIN" 2>/dev/null || true
	iptables -t nat -D PREROUTING -i "$LAN_IF" -s "$CLIENT_IP/32" -p udp --dport 53 -j REDIRECT --to-ports "$DNS_PORT" 2>/dev/null || true
	iptables -t nat -D PREROUTING -i "$LAN_IF" -s "$CLIENT_IP/32" -p tcp --dport 53 -j REDIRECT --to-ports "$DNS_PORT" 2>/dev/null || true
	iptables -D FORWARD -i "$LAN_IF" -s "$CLIENT_IP/32" -d 198.18.0.0/16 -p udp --dport 443 -j REJECT 2>/dev/null || true
	iptables -t nat -F "$CHAIN" 2>/dev/null || true
	iptables -t nat -X "$CHAIN" 2>/dev/null || true
}

add_rules() {
	delete_rules
	iptables -t nat -N "$CHAIN" 2>/dev/null || true
	for cidr in \
		0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 \
		169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 \
		224.0.0.0/4 240.0.0.0/4
	do
		iptables -t nat -A "$CHAIN" -d "$cidr" -j RETURN
	done
	iptables -t nat -A "$CHAIN" -p tcp -j REDIRECT --to-ports "$REDIR_PORT"
	iptables -t nat -I PREROUTING -i "$LAN_IF" -s "$CLIENT_IP/32" -p tcp -j "$CHAIN"
	iptables -t nat -I PREROUTING -i "$LAN_IF" -s "$CLIENT_IP/32" -p udp --dport 53 -j REDIRECT --to-ports "$DNS_PORT"
	iptables -t nat -I PREROUTING -i "$LAN_IF" -s "$CLIENT_IP/32" -p tcp --dport 53 -j REDIRECT --to-ports "$DNS_PORT"
	iptables -I FORWARD -i "$LAN_IF" -s "$CLIENT_IP/32" -d 198.18.0.0/16 -p udp --dport 443 -j REJECT
}

case "${1:-}" in
	add)
		add_rules
		;;
	delete|del|stop)
		delete_rules
		;;
	*)
		echo "usage: $0 add|delete" >&2
		exit 2
		;;
esac

