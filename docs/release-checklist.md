# Release Checklist

Use this checklist for every LazyNet release.

## Before Commit

- [ ] Source files updated.
- [ ] Generated files were not hand-edited.
- [ ] Secrets and private runtime files are not present in git status.
- [ ] `VERSION` updated for user-visible changes.
- [ ] `CHANGELOG.md` updated.
- [ ] Docs updated when behavior changed.

## Local Verification

- [ ] `scripts/test.sh` passes.
- [ ] `scripts/build.sh` passes.
- [ ] Dashboard JavaScript passes syntax check.
- [ ] Dashboard was opened in a browser when UI changed.

## OpenWrt Verification

- [ ] Deploy completed.
- [ ] Mihomo config preflight passed.
- [ ] LazyNet service is running.
- [ ] Legacy conflicting services are stopped or inactive.
- [ ] Ports `7890`, `7892`, `7874`, and `9090` are listening.
- [ ] Netflix DNS returns fake-IP.
- [ ] PlayStation DNS returns real IP.
- [ ] GitHub proxy smoke check passes.
- [ ] Netflix proxy smoke check passes.
- [ ] ChatGPT tunnel check passes.

## After Release

- [ ] Push to GitHub.
- [ ] Refresh dashboard status.
- [ ] Confirm dashboard version and commit.
- [ ] Move completed backlog items or update their status.

