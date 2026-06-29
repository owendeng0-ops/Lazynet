#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

. "$REPO_ROOT/scripts/lib/version.sh"

ENV_FILE="${LAZYNET_ENV:-/etc/lazynet/lazynet.env}"
if [ -f "$ENV_FILE" ]; then
	. "$ENV_FILE"
fi

VERGE_OUTPUT="${VERGE_OUTPUT:-$REPO_ROOT/configs/verge/generated/lazynet.verge.yaml}"
PROXY_GROUP_NAME="${PROXY_GROUP_NAME:-Proxy}"

mkdir -p "$(dirname "$VERGE_OUTPUT")"

emit_verge_rules() {
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

{
	lazynet_metadata_comments
	printf '\n'
	printf 'prepend-rules:\n'
	emit_verge_rules "$REPO_ROOT/rules/game/playstation.direct.domains" "DIRECT"
	emit_verge_rules "$REPO_ROOT/rules/ai/proxy.domains" "$PROXY_GROUP_NAME"
	emit_verge_rules "$REPO_ROOT/rules/github/proxy.domains" "$PROXY_GROUP_NAME"
	emit_verge_rules "$REPO_ROOT/rules/media/netflix.proxy.domains" "$PROXY_GROUP_NAME"
	emit_verge_rules "$REPO_ROOT/rules/china/direct.domains" "DIRECT"
	printf '\n'
	printf 'prepend-proxy-groups:\n'
	printf '  - name: %s\n' "$PROXY_GROUP_NAME"
	printf '    type: select\n'
	printf '    proxies:\n'
	printf '      - DIRECT\n'
} > "$VERGE_OUTPUT"

printf 'Generated %s\n' "$VERGE_OUTPUT"

