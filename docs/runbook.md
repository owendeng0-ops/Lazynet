# Runbook

This runbook keeps daily LazyNet operations out of chat history.

## Daily Check

1. Open the dashboard.
2. Confirm overall status is healthy.
3. Confirm LazyNet service is running and legacy services are inactive.
4. Confirm ports `7890`, `7892`, `7874`, and `9090` are open.
5. Confirm the current node and real exit location match expectation.
6. Confirm GitHub, Netflix, and ChatGPT probes connect through the proxy.

## Add A Device

### Manual Proxy

Use this for phones and computers.

```text
Server: 192.168.3.2
Port: 7890
Type: HTTP or SOCKS5
```

Then confirm the dashboard still shows healthy proxy and node checks.

### Transparent Proxy

Use this for devices that cannot run a client, such as a game console or TV.

1. Reserve a stable IP for the device in the main router or DHCP server.
2. Open the dashboard device access page.
3. Enter the new device IP.
4. Copy the generated OpenWrt command.
5. Run it on OpenWrt.
6. Refresh dashboard status.

The current v1 behavior manages one transparent proxy target at a time through `LAZYNET_CLIENT_IP`.

## Local Build

```sh
scripts/test.sh
scripts/build.sh
```

## OpenWrt Deploy

```sh
scripts/install-openwrt.sh
/etc/init.d/lazynet enable
/etc/init.d/lazynet restart
```

The deployed runtime config is generated under `/tmp/lazynet/`.

## Healthcheck

```sh
scripts/healthcheck.sh
scripts/node-monitor.sh
```

Expected signs of health:

- LazyNet service is running.
- Mihomo API responds on `127.0.0.1:9090`.
- Netflix resolves to a fake-IP address.
- PlayStation resolves to real IP and stays direct.
- Proxy smoke checks connect through `192.168.3.2:7890`.

## Incident Response

### Node Looks Wrong

1. Check dashboard real exit.
2. Run node monitor.
3. Switch or validate the current Mihomo group selection.
4. Avoid changing rules until the node state is understood.

### Netflix Fails

1. Check DNS result for Netflix.
2. Check current node and exit location.
3. Check proxy smoke test result.
4. Keep PlayStation and Sony domains direct.

### PSN Or Console Services Fail

1. Confirm PlayStation/Sony domains are real-IP.
2. Confirm UDP 443 blocking is scoped to the transparent proxy client and fake-IP range.
3. Do not apply broad LAN firewall changes.

### Dashboard Looks Stale

1. Refresh `dashboard/status.json`.
2. Reload the browser.
3. Confirm the git commit shown in the dashboard matches the deployed version.

## Rollback

For a bad LazyNet deployment, stop LazyNet and restore the previously working service or config backup only after checking which layer failed.

Do not delete private files under `/etc/lazynet/`.

