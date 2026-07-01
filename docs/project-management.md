# Project Management

LazyNet is managed as a long-running home-network platform project, not as a collection of one-off proxy snippets.

## Charter

LazyNet makes OpenWrt the control plane for the home network. It should provide stable proxy routing, DNS policy, client configuration generation, device onboarding, monitoring, and recovery workflows.

The project exists to answer three practical questions quickly:

1. Is the network healthy right now?
2. Which devices are using LazyNet, and how are they connected?
3. What changed between a working day and a broken day?

## Product Principles

1. OpenWrt is the server and control plane.
2. Source changes happen in `rules/`, `configs/`, and `scripts/`.
3. Generated YAML and client profiles are build outputs.
4. Secrets, tokens, passwords, subscriptions, and API keys stay under `/etc/lazynet/`.
5. Transparent proxying is scoped to explicit devices by default.
6. Every generated output carries version, generated time, rules version, and git commit.

## Current Scope

In scope for v1:

- OpenWrt runtime management.
- Mihomo config generation.
- Scoped transparent proxy for selected devices.
- Manual proxy endpoint for phones and computers.
- Dashboard monitoring.
- Device access workflow.
- Modular DNS, AI, GitHub, Netflix, game, monitor, and notify rules.

Out of scope until explicitly planned:

- Whole-LAN transparent proxy by default.
- Storing subscriptions or tokens in git.
- Replacing the router UI.
- Heavy OpenWrt package changes on small overlay storage.
- Automatic changes to router credentials.

## Workstreams

| Workstream | Purpose | Source |
| --- | --- | --- |
| Network | OpenWrt service, ports, firewall, device scope | `configs/openwrt/`, `scripts/install-openwrt.sh` |
| Mihomo | Runtime config generation and proxy groups | `scripts/generate-mihomo.sh`, `configs/mihomo/` |
| DNS | fake-IP, real-IP, direct-domain policy | `rules/china/`, `rules/game/`, `docs/openwrt-runtime.md` |
| Device Access | Manual proxy and transparent proxy onboarding | `dashboard/`, `/etc/lazynet/lazynet.env` |
| Monitoring | Health, node, port, DNS, proxy checks | `scripts/healthcheck.sh`, `scripts/node-monitor.sh` |
| Client Outputs | Shadowrocket, Verge, manifest generation | `scripts/generate-*.sh`, `configs/*/generated/` |
| Operations | Build, test, deploy, rollback, release routine | `scripts/test.sh`, `scripts/build.sh`, `docs/runbook.md` |

## Milestones

| Milestone | Goal | Exit Criteria |
| --- | --- | --- |
| v1.0 Platform Baseline | OpenWrt-centered runtime with dashboard | Build/test pass, service deploys, dashboard shows live status |
| v1.1 Device Access | Make onboarding devices practical | Dashboard shows manual proxy, transparent proxy target, checks, and clear commands |
| v1.2 Monitoring | Make node failures visible earlier | Node health, exit location, target probes, and notification path are reliable |
| v1.3 DNS Layer | Integrate AdGuard Home and DNS policy | DNS rules are observable and separately testable |
| v2.0 Control Plane | Move from display to controlled actions | Confirmed one-click update, device switch, rollback, and generated client download |

## Definition Of Done

A change is done only when:

1. Source files are updated, not generated outputs by hand.
2. `scripts/test.sh` passes.
3. `scripts/build.sh` passes when generation behavior is touched.
4. Dashboard changes are checked in a browser.
5. OpenWrt changes are deployed and live-tested before being called complete.
6. README, changelog, roadmap, or runbook are updated when behavior changes.
7. No secrets or private runtime files are committed.

## Release Routine

1. Update source files.
2. Run local test and build.
3. Update `VERSION` and `CHANGELOG.md` for user-visible changes.
4. Commit with a focused message.
5. Push to GitHub.
6. Deploy to OpenWrt.
7. Run live test.
8. Refresh dashboard status.
9. Record remaining risks in `docs/backlog.md`.

## Decision Rules

- Prefer small, reversible router changes.
- Keep PS5 and game traffic safe while changing media and AI routing.
- Do not broaden transparent proxy scope without an explicit task.
- If a node breaks, check current node and exit before changing rules.
- If a generated config breaks, compare version metadata before editing anything.

