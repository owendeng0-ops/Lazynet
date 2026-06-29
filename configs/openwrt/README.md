# OpenWrt Configs

OpenWrt is LazyNet's first-class runtime target.

Runtime state should stay under `/etc/lazynet/` and `/tmp/lazynet/`. Avoid storing large Mihomo cores or generated files on a small overlay filesystem when `/tmp` is available.

Files:

- `lazynet.init`: OpenWrt `procd` service for Mihomo.
- `firewall-iptables.sh`: scoped transparent proxy rules for the configured client.
- `crontab.fragment`: optional scheduled healthcheck and update entries.
