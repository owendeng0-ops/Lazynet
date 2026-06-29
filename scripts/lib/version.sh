#!/bin/sh

set -eu

if [ -n "${REPO_ROOT:-}" ]; then
	repo_root="$REPO_ROOT"
else
	script_dir=$(dirname "$0")
	repo_root=$(cd "$script_dir/../.." && pwd)
fi

lazynet_version() {
	if [ -f "$repo_root/VERSION" ]; then
		sed -n '1p' "$repo_root/VERSION"
	else
		printf '%s\n' "0.0.0"
	fi
}

lazynet_commit() {
	if command -v git >/dev/null 2>&1 && git -C "$repo_root" rev-parse --short HEAD >/dev/null 2>&1; then
		git -C "$repo_root" rev-parse --short HEAD
	else
		printf '%s\n' "unknown"
	fi
}

lazynet_generated_at() {
	date -u '+%Y-%m-%dT%H:%M:%SZ'
}

lazynet_rules_version() {
	if command -v git >/dev/null 2>&1 && git -C "$repo_root" rev-parse --short HEAD >/dev/null 2>&1; then
		git -C "$repo_root" rev-parse --short HEAD
	else
		lazynet_version
	fi
}
