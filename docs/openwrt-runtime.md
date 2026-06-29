# OpenWrt Runtime

LazyNet's first runtime target is the OpenWrt side router.

## Runtime Paths

```text
/etc/lazynet/                 private persistent config
/etc/lazynet/lazynet.env      local environment
/etc/lazynet/mihomo/          private Mihomo providers or subscriptions
/tmp/lazynet/                 generated runtime files
```

Use `/tmp` for large or frequently replaced runtime artifacts when the overlay filesystem is small.

## Default Transparent Proxy Scope

Transparent interception should be scoped to the configured client by default:

```text
LAZYNET_CLIENT_IP=192.168.3.50
```

Do not redirect the entire LAN unless the change is deliberate and reviewed.

## PSN And Sony Safety

PlayStation and Sony domains are direct by default:

```text
playstation.net
playstation.com
playstationnetwork.com
sonyentertainmentnetwork.com
sony.com
sony.co.jp
```

They are also placed in Mihomo `fake-ip-filter` and `nameserver-policy` so PSN stays real-IP and direct.

## Netflix

Netflix domains live in `rules/media/netflix.proxy.domains` and route through `MEDIA_GROUP_NAME`.

If Netflix fails with DNS errors, check DNS upstreams and current node health before making broad firewall or LAN changes.

