# Changelog

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
