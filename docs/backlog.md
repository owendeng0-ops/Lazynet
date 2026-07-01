# Backlog

This backlog is the working project board for LazyNet. Keep it small, current, and tied to observable user value.

## Now

| ID | Area | Task | Status | Acceptance |
| --- | --- | --- | --- | --- |
| LN-101 | Device Access | Promote the access page from command copy to confirmed one-click apply | Planned | User enters a device IP, confirms, LazyNet updates OpenWrt and refreshes status |
| LN-102 | Device Access | Show known LAN devices and identify current client | Planned | Dashboard lists detected device IPs, names when available, and current transparent target |
| LN-103 | Monitoring | Add node failure reason display | Planned | Dashboard distinguishes timeout, DNS failure, blocked target, and bad exit |
| LN-104 | Operations | Add rollback command to runbook and dashboard copy block | Planned | User can restore previous LazyNet runtime without hunting through chat history |

## Next

| ID | Area | Task | Status | Acceptance |
| --- | --- | --- | --- | --- |
| LN-201 | Client Outputs | Add download links for generated Shadowrocket and Verge profiles | Planned | Dashboard exposes generated profile paths with version metadata |
| LN-202 | Notify | Add notification adapter for node failure | Planned | Healthcheck can send a private webhook without committing secrets |
| LN-203 | DNS | Document AdGuard Home integration path | Planned | Runtime doc explains Mihomo DNS and AdGuard Home responsibilities |
| LN-204 | Testing | Add dashboard smoke test script | Planned | Test suite verifies tab switching and access command rendering |

## Later

| ID | Area | Task | Status | Acceptance |
| --- | --- | --- | --- | --- |
| LN-301 | Dashboard | Add historical status snapshots | Backlog | User can compare current status with previous healthy state |
| LN-302 | Control Plane | Add one-click update workflow | Backlog | Dashboard can run update with confirmation and show result |
| LN-303 | Network | Support multiple transparent proxy devices | Backlog | Multiple explicit IPs can be managed without whole-LAN interception |
| LN-304 | Release | Add automated release notes generation | Backlog | Version, commit, test evidence, and deployment result are summarized automatically |

## Parking Lot

- Whole-LAN transparent proxy mode.
- Web authentication for the dashboard.
- Docker or x86 router runtime.
- HomeAssistant integration.
- Jellyfin routing and monitoring.

