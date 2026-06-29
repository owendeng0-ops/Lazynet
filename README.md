# LazyNet

LazyNet is an OpenWrt-centered home network project. OpenWrt is the server, Mihomo is the policy engine, AdGuard Home is the DNS layer, and phone or desktop clients are generated outputs rather than the source of truth.

## Background

LazyNet started from a real home-network problem: keeping streaming, AI tools, GitHub, games, and daily devices stable without hand-editing fragile client configs every time something changes.

The old pattern was scattered and easy to break. Android, Shadowrocket, Windows, OpenWrt, DNS rules, subscription files, and one-off scripts could all drift in different directions. When something worked yesterday and failed today, it was hard to answer what changed.

LazyNet makes OpenWrt the stable center of the system. Rules, scripts, and templates live in git. Private subscriptions, tokens, passwords, and runtime state stay on the router under `/etc/lazynet/`. Generated YAML and client profiles are treated as build artifacts, not handwritten source.

## Expected Outcome

LazyNet should eventually make the home network:

1. Recoverable: a fresh OpenWrt device can be rebuilt from documented steps and local private files.
2. Observable: every generated config records LazyNet version, generation time, rules version, and git commit.
3. Modular: DNS, AI, Netflix, GitHub, Game, Monitor, Notify, and client outputs can be changed independently.
4. Safe: transparent proxying starts with a specific client or device, not the whole LAN by accident.
5. Portable: Android, iPhone, Windows, Shadowrocket, Verge, and other clients are generated from the same source rules.
6. Maintainable: fixes happen in `rules/`, `scripts/`, and `configs/`, then configs are regenerated.

The long-term goal is a small home-network platform: one place to update, check, monitor, roll back, and regenerate network policy.

## Principles

1. OpenWrt is the server, not a client.
2. YAML is generated output. Source rules live in `rules/`, scripts live in `scripts/`, and templates live in `configs/`.
3. GitHub stores code only. Tokens, passwords, subscription URLs, API keys, and personal runtime state stay under `/etc/lazynet/`.
4. Every feature is modular: Network, DNS, AI, Netflix, GitHub, Game, Monitor, and Notify can evolve independently.
5. Every generated config carries version metadata: LazyNet version, generated time, rules version, and git commit.

## Layout

```text
LazyNet/
+-- docs/
+-- configs/
|   +-- mihomo/
|   +-- shadowrocket/
|   +-- verge/
|   +-- openwrt/
+-- rules/
|   +-- ai/
|   +-- game/
|   +-- github/
|   +-- media/
|   +-- china/
|   +-- custom/
+-- scripts/
+-- dashboard/
+-- CHANGELOG.md
```

## First Target

The first supported runtime target is OpenWrt with Mihomo. The current design keeps transparent proxying scoped to a configured client by default, which avoids turning every LAN device into an accidental test subject.

## Local Secrets

Create local files on OpenWrt, not in this repository:

```text
/etc/lazynet/lazynet.env
/etc/lazynet/mihomo/private-providers.yaml
/etc/lazynet/mihomo/subscription.yaml
```

Use `configs/lazynet.env.example` as the starting point.

## Generate Mihomo

```sh
cp configs/lazynet.env.example /etc/lazynet/lazynet.env
scripts/generate-mihomo.sh
```

Generated files are written to `configs/mihomo/generated/` by default and are ignored by git.
