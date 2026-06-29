#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
TMP_DIR="$REPO_ROOT/tmp/test-build"
SH_BIN="${SH_BIN:-sh}"

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

pass() {
	printf '[ok] %s\n' "$1"
}

fail() {
	printf '[fail] %s\n' "$1" >&2
	exit 1
}

for file in \
	"$REPO_ROOT"/scripts/*.sh \
	"$REPO_ROOT"/scripts/lib/*.sh \
	"$REPO_ROOT"/configs/openwrt/*.sh \
	"$REPO_ROOT"/configs/openwrt/*.init
do
	[ -f "$file" ] || continue
	"$SH_BIN" -n "$file" || fail "shell syntax: $file"
done
pass "shell syntax"

MANIFEST_OUTPUT="$TMP_DIR/lazynet.manifest.json" "$SH_BIN" "$REPO_ROOT/scripts/generate-manifest.sh" >/dev/null
MIHOMO_OUTPUT="$TMP_DIR/lazynet.mihomo.yaml" "$SH_BIN" "$REPO_ROOT/scripts/generate-mihomo.sh" >/dev/null
SHADOWROCKET_OUTPUT="$TMP_DIR/lazynet.shadowrocket.conf" "$SH_BIN" "$REPO_ROOT/scripts/generate-shadowrocket.sh" >/dev/null
VERGE_OUTPUT="$TMP_DIR/lazynet.verge.yaml" "$SH_BIN" "$REPO_ROOT/scripts/generate-verge.sh" >/dev/null
pass "generators"

for file in \
	"$TMP_DIR/lazynet.mihomo.yaml" \
	"$TMP_DIR/lazynet.shadowrocket.conf" \
	"$TMP_DIR/lazynet.verge.yaml"
do
	grep -q "LazyNet-Version:" "$file" || fail "missing version metadata: $file"
	grep -q "Generated-At:" "$file" || fail "missing generated timestamp: $file"
	grep -q "Git-Commit:" "$file" || fail "missing git commit metadata: $file"
done
pass "version metadata"

grep -q '"gitCommit"' "$TMP_DIR/lazynet.manifest.json" || fail "manifest missing gitCommit"
grep -q '"targets"' "$TMP_DIR/lazynet.manifest.json" || fail "manifest missing targets"
pass "manifest"

grep -q "DOMAIN-SUFFIX,playstation.net,DIRECT" "$TMP_DIR/lazynet.mihomo.yaml" || fail "PSN direct rule missing"
grep -q "'+.playstation.net': 192.168.3.1" "$TMP_DIR/lazynet.mihomo.yaml" || fail "PSN real-IP DNS policy missing"
grep -q "geoip: false" "$TMP_DIR/lazynet.mihomo.yaml" || fail "DNS fallback GeoIP should be disabled"
grep -q "DOMAIN-SUFFIX,netflix.com" "$TMP_DIR/lazynet.mihomo.yaml" || fail "Netflix rule missing"
pass "routing rules"

for generated in \
	"$REPO_ROOT/configs/manifest/generated/lazynet.manifest.json" \
	"$REPO_ROOT/configs/mihomo/generated/lazynet.mihomo.yaml" \
	"$REPO_ROOT/configs/shadowrocket/generated/lazynet.shadowrocket.conf" \
	"$REPO_ROOT/configs/verge/generated/lazynet.verge.yaml"
do
	if ! git -C "$REPO_ROOT" check-ignore -q "$generated"; then
		fail "generated output is not ignored: $generated"
	fi
done
pass "generated outputs ignored"

if grep -RInE 'sub\.jsysubtoken|api[_-]?key *= *[^[:space:]"]|password *= *[^[:space:]"]|token *= *[^[:space:]"]' \
	"$REPO_ROOT" \
	--exclude-dir=.git \
	--exclude-dir=tmp \
	--exclude-dir=build \
	--exclude='*.sample.json'
then
	fail "possible secret found"
fi
pass "secret scan"

printf 'LazyNet tests passed.\n'
