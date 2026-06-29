#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

. "$REPO_ROOT/scripts/lib/version.sh"

ENV_FILE="${LAZYNET_ENV:-/etc/lazynet/lazynet.env}"
if [ -f "$ENV_FILE" ]; then
	. "$ENV_FILE"
fi

LAZYNET_RUNTIME_DIR="${LAZYNET_RUNTIME_DIR:-$REPO_ROOT/tmp}"
MIHOMO_OUTPUT="${MIHOMO_OUTPUT:-$REPO_ROOT/configs/mihomo/generated/lazynet.mihomo.yaml}"
MIHOMO_PRIVATE_PROVIDERS="${MIHOMO_PRIVATE_PROVIDERS:-/etc/lazynet/mihomo/private-providers.yaml}"

MIHOMO_MIXED_PORT="${MIHOMO_MIXED_PORT:-7890}"
MIHOMO_REDIR_PORT="${MIHOMO_REDIR_PORT:-7892}"
MIHOMO_DNS_PORT="${MIHOMO_DNS_PORT:-7874}"
MIHOMO_API_ADDR="${MIHOMO_API_ADDR:-0.0.0.0:9090}"

PROXY_GROUP_NAME="${PROXY_GROUP_NAME:-Proxy}"
AI_GROUP_NAME="${AI_GROUP_NAME:-$PROXY_GROUP_NAME}"
MEDIA_GROUP_NAME="${MEDIA_GROUP_NAME:-$PROXY_GROUP_NAME}"
GITHUB_GROUP_NAME="${GITHUB_GROUP_NAME:-$PROXY_GROUP_NAME}"

mkdir -p "$(dirname "$MIHOMO_OUTPUT")" "$LAZYNET_RUNTIME_DIR"

emit_domain_rules() {
	file="$1"
	target="$2"

	[ -f "$file" ] || return 0
	while IFS= read -r domain || [ -n "$domain" ]; do
		case "$domain" in
			''|'#'*) continue ;;
		esac
		domain=${domain#+.}
		printf '  - DOMAIN-SUFFIX,%s,%s\n' "$domain" "$target"
	done < "$file"
}

emit_fake_ip_filter() {
	file="$1"

	[ -f "$file" ] || return 0
	while IFS= read -r domain || [ -n "$domain" ]; do
		case "$domain" in
			''|'#'*) continue ;;
		esac
		domain=${domain#+.}
		printf "    - '+.%s'\n" "$domain"
	done < "$file"
}

emit_nameserver_policy() {
	file="$1"
	resolver="$2"

	[ -f "$file" ] || return 0
	while IFS= read -r domain || [ -n "$domain" ]; do
		case "$domain" in
			''|'#'*) continue ;;
		esac
		domain=${domain#+.}
		printf "    '+.%s': %s\n" "$domain" "$resolver"
	done < "$file"
}

{
	lazynet_metadata_comments
	printf '\n'
	printf 'mixed-port: %s\n' "$MIHOMO_MIXED_PORT"
	printf 'redir-port: %s\n' "$MIHOMO_REDIR_PORT"
	printf 'allow-lan: true\n'
	printf 'mode: rule\n'
	printf 'log-level: info\n'
	printf "external-controller: '%s'\n" "$MIHOMO_API_ADDR"
	printf '\n'
	printf 'dns:\n'
	printf '  enable: true\n'
	printf "  listen: 0.0.0.0:%s\n" "$MIHOMO_DNS_PORT"
	printf '  enhanced-mode: fake-ip\n'
	printf '  default-nameserver: [192.168.3.1, 223.5.5.5, 119.29.29.29]\n'
	printf '  nameserver: [192.168.3.1, 223.5.5.5, 119.29.29.29]\n'
	printf '  fallback: [1.1.1.1, 8.8.8.8]\n'
	printf '  nameserver-policy:\n'
	emit_nameserver_policy "$REPO_ROOT/rules/game/playstation.direct.domains" "192.168.3.1"
	printf '  fake-ip-filter:\n'
	emit_fake_ip_filter "$REPO_ROOT/rules/game/playstation.direct.domains"
	printf '\n'

	if [ -f "$MIHOMO_PRIVATE_PROVIDERS" ]; then
		printf '# Private provider and proxy-group section starts here.\n'
		cat "$MIHOMO_PRIVATE_PROVIDERS"
		printf '\n'
	else
		printf '# No private provider file found. DIRECT-only fallback for local generation.\n'
		printf 'proxy-groups:\n'
		printf '  - name: %s\n' "$PROXY_GROUP_NAME"
		printf '    type: select\n'
		printf '    proxies: [DIRECT]\n'
	fi

	printf '\n'
	printf 'rules:\n'
	emit_domain_rules "$REPO_ROOT/rules/game/playstation.direct.domains" "DIRECT"
	emit_domain_rules "$REPO_ROOT/rules/ai/proxy.domains" "$AI_GROUP_NAME"
	emit_domain_rules "$REPO_ROOT/rules/github/proxy.domains" "$GITHUB_GROUP_NAME"
	emit_domain_rules "$REPO_ROOT/rules/media/netflix.proxy.domains" "$MEDIA_GROUP_NAME"
	emit_domain_rules "$REPO_ROOT/rules/china/direct.domains" "DIRECT"
	printf '  - MATCH,%s\n' "$PROXY_GROUP_NAME"
} > "$MIHOMO_OUTPUT"

printf 'Generated %s\n' "$MIHOMO_OUTPUT"
