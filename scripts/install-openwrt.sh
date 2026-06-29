#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

LAZYNET_HOME="${LAZYNET_HOME:-/etc/lazynet}"
APP_DIR="${LAZYNET_APP_DIR:-$LAZYNET_HOME/app}"
ENV_FILE="${LAZYNET_ENV:-$LAZYNET_HOME/lazynet.env}"

mkdir -p "$APP_DIR" "$LAZYNET_HOME/mihomo" "$LAZYNET_HOME/rules" /tmp/lazynet

copy_dir() {
	src="$1"
	dst="$2"
	rm -rf "$dst"
	mkdir -p "$(dirname "$dst")"
	cp -R "$src" "$dst"
}

copy_dir "$REPO_ROOT/configs" "$APP_DIR/configs"
copy_dir "$REPO_ROOT/docs" "$APP_DIR/docs"
copy_dir "$REPO_ROOT/rules" "$APP_DIR/rules"
copy_dir "$REPO_ROOT/scripts" "$APP_DIR/scripts"
cp "$REPO_ROOT/README.md" "$APP_DIR/README.md"
cp "$REPO_ROOT/VERSION" "$APP_DIR/VERSION"

if [ ! -f "$ENV_FILE" ]; then
	cp "$REPO_ROOT/configs/lazynet.env.example" "$ENV_FILE"
	chmod 600 "$ENV_FILE"
fi

cp "$REPO_ROOT/configs/openwrt/lazynet.init" /etc/init.d/lazynet
chmod +x /etc/init.d/lazynet
cp "$REPO_ROOT/configs/openwrt/firewall-iptables.sh" /usr/bin/lazynet-firewall
chmod +x /usr/bin/lazynet-firewall

chmod +x "$APP_DIR"/scripts/*.sh "$APP_DIR"/scripts/lib/*.sh

echo "LazyNet installed to $APP_DIR"
echo "Edit $ENV_FILE before enabling or starting the service."
echo "Then run: /etc/init.d/lazynet enable && /etc/init.d/lazynet start"

