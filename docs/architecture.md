# Architecture

LazyNet treats OpenWrt as the server.

```text
OpenWrt
  |
  +-- Mihomo
  |     |
  |     +-- generated routing config
  |
  +-- AdGuard Home
  |     |
  |     +-- DNS policy and filtering
  |
  +-- scripts
        |
        +-- update, healthcheck, notify, speedtest
```

Clients such as Android, iPhone, Windows, Shadowrocket, and Verge are downstream outputs. They should not become the source of truth for LazyNet rules.

## Module Boundaries

- Network: OpenWrt interfaces, NAT, and transparent interception.
- DNS: AdGuard Home, Mihomo DNS, fake-IP policy, and direct-domain policies.
- AI: AI service routing.
- Netflix: media routing, unlock checks, and stability tests.
- GitHub: developer workflow routing.
- Game: console services and direct routes for PSN/Sony.
- Monitor: health checks and status reporting.
- Notify: webhook or message delivery.

Each module should be safe to update without forcing unrelated client rewrites.

