# Mihomo Configs

This directory stores Mihomo generation inputs and ignored generated output.

Committed files should describe reusable structure only. Private subscription URLs, providers, node names, API secrets, and generated runtime configs belong under `/etc/lazynet/` on OpenWrt.

When `MIHOMO_BASE_CONFIG` exists, LazyNet reuses its private `proxies`, `proxy-groups`, and provider sections, then replaces only runtime ports, DNS policy, and rules. This keeps subscriptions and node data out of git while allowing LazyNet to own the generated policy layer.

Default generated output path:

```text
configs/mihomo/generated/lazynet.mihomo.yaml
```

OpenWrt runtime output path:

```text
/tmp/lazynet/mihomo.yaml
```
