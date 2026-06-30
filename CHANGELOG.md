# Changelog

## 1.0.7 - 2026-06-30

- Add a dashboard device access page for daily onboarding.
- Show manual proxy endpoint, current transparent proxy device, and access checks.
- Generate copyable OpenWrt commands for changing the transparent proxy client IP.

## 1.0.6 - 2026-06-30

- Localize the dashboard UI for Chinese daily use.
- Translate runtime, service, port, node, rule, output, and module labels.
- Translate service boot-state labels and inactive legacy service states.

## 1.0.5 - 2026-06-30

- Show real proxy exit IP, country, and city in node monitoring.
- Clarify whether LazyNet/OpenWrt and local desktop Clash Verge are using different exits.

## 1.0.4 - 2026-06-30

- Add current-node monitoring for the configured Mihomo proxy group.
- Show node health on the dashboard with GitHub, Netflix, and ChatGPT probes.
- Add `scripts/node-monitor.sh` for OpenWrt-side node checks.

## 1.0.3 - 2026-06-30

- Replace the placeholder dashboard with a live operations dashboard.
- Add runtime, service, port, DNS, proxy, rule-scope, output, and module panels.
- Make `dashboard/status.json` a local ignored runtime artifact.
- Extend tests to validate dashboard JavaScript and sample status JSON.

## 1.0.2 - 2026-06-30

- Reuse an existing private Mihomo base config on OpenWrt instead of falling back to DIRECT-only output.
- Disable Mihomo DNS fallback GeoIP filtering to avoid MMDB downloads during router-side validation.
- Stop conflicting OpenClash or ps5clash services before starting LazyNet.
- Preserve generated config revision metadata after installing without a `.git` directory.

## 1.0.1 - 2026-06-29

- Add a full local build pipeline for manifest, Mihomo, Shadowrocket, and Verge outputs.
- Add OpenWrt `lazynet` procd service, scoped firewall template, cron fragment, and installer.
- Add a static dashboard shell for platform status.
- Add `scripts/test.sh` for repeatable platform checks.
- Keep generated files and private runtime config out of git.

## 1.0.0 - 2026-06-29

- Initialize LazyNet as an OpenWrt-centered home network project.
- Add modular directories for configs, rules, scripts, dashboard, and docs.
- Add generated-config version metadata as a first-class requirement.
- Add initial Mihomo generation, healthcheck, update, notify, and speedtest scripts.
