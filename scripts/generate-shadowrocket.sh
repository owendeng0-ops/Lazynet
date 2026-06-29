#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

. "$REPO_ROOT/scripts/lib/version.sh"

ENV_FILE="${LAZYNET_ENV:-/etc/lazynet/lazynet.env}"
if [ -f "$ENV_FILE" ]; then
	. "$ENV_FILE"
fi

SHADOWROCKET_OUTPUT="${SHADOWROCKET_OUTPUT:-$REPO_ROOT/configs/shadowrocket/generated/lazynet.shadowrocket.conf}"
PROXY_POLICY_NAME="${PROXY_POLICY_NAME:-PROXY}"

mkdir -p "$(dirname "$SHADOWROCKET_OUTPUT")"

emit_shadowrocket_rules() {
	file="$1"
	policy="$2"

	[ -f "$file" ] || return 0
	while IFS= read -r domain || [ -n "$domain" ]; do
		case "$domain" in
			''|'#'*) continue ;;
		esac
		domain=${domain#+.}
		printf 'DOMAIN-SUFFIX,%s,%s\n' "$domain" "$policy"
	done < "$file"
}

{
	lazynet_metadata_comments
	printf '\n'
	printf '[General]\n'
	printf 'bypass-system = true\n'
	printf 'skip-proxy = 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, localhost, *.local\n'
	printf 'dns-server = system\n'
	printf '\n'
	printf '[Rule]\n'
	emit_shadowrocket_rules "$REPO_ROOT/rules/game/playstation.direct.domains" "DIRECT"
	emit_shadowrocket_rules "$REPO_ROOT/rules/ai/proxy.domains" "$PROXY_POLICY_NAME"
	emit_shadowrocket_rules "$REPO_ROOT/rules/github/proxy.domains" "$PROXY_POLICY_NAME"
	emit_shadowrocket_rules "$REPO_ROOT/rules/media/netflix.proxy.domains" "$PROXY_POLICY_NAME"
	emit_shadowrocket_rules "$REPO_ROOT/rules/china/direct.domains" "DIRECT"
	printf 'FINAL,%s\n' "$PROXY_POLICY_NAME"
	printf '\n'
	printf '[Proxy Group]\n'
	printf '# Add private Shadowrocket node definitions on the client or generate them from /etc/lazynet later.\n'
	printf '%s = select, DIRECT\n' "$PROXY_POLICY_NAME"
} > "$SHADOWROCKET_OUTPUT"

printf 'Generated %s\n' "$SHADOWROCKET_OUTPUT"

