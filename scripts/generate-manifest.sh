#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

. "$REPO_ROOT/scripts/lib/version.sh"

MANIFEST_OUTPUT="${MANIFEST_OUTPUT:-$REPO_ROOT/configs/manifest/generated/lazynet.manifest.json}"
mkdir -p "$(dirname "$MANIFEST_OUTPUT")"

version=$(lazynet_version)
generated_at=$(lazynet_generated_at)
rules_version=$(lazynet_rules_version)
commit=$(lazynet_commit)

cat > "$MANIFEST_OUTPUT" <<EOF
{
  "name": "LazyNet",
  "version": "$version",
  "generatedAt": "$generated_at",
  "rulesVersion": "$rules_version",
  "gitCommit": "$commit",
  "targets": [
    "openwrt",
    "mihomo",
    "shadowrocket",
    "verge"
  ]
}
EOF

printf 'Generated %s\n' "$MANIFEST_OUTPUT"

