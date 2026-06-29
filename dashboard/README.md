# Dashboard

Open `index.html` directly in a browser for the static LazyNet dashboard.

When deployed behind OpenWrt or a local web server, write runtime status to `dashboard/status.json`. Without that file, the dashboard shows a safe built-in development status.

The dashboard expects these status sections:

- `runtime`: router, client scope, core, overlay, and runtime directory.
- `services`: LazyNet and legacy service states.
- `ports`: Mihomo mixed, redir, DNS, and API ports.
- `dns`: key DNS behavior such as Netflix fake-IP and PlayStation real-IP.
- `proxy`: outbound smoke checks.
- `node`: current selected node and per-target node probes.
- `rules`: source rule counts and routing targets.
- `outputs`: generated config artifacts.
