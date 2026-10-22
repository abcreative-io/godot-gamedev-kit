---
name: godot-commit-gate
description: Build or tighten a hard pre-commit/pre-push gate for a Godot 4 project — import, tests, headless smoke, warnings-as-errors — and enforce it with an opt-in git hook so it cannot be skipped by accident. Use when agents commit code or a bug reached main untested.
---

# Godot commit gate

A skill is advice the agent can skip; a gate cannot be skipped. Make every commit and push pass the same headless checks.

## What the gate runs (all headless, exit non-zero on any failure)
1. `godot --headless --path . --import`
2. the test runner (`--script tests/run_tests.gd`), fail on exit code or any `SCRIPT ERROR`
3. smoke: `--quit-after 180`, fail on non-zero exit or any `ERROR` line (run a second one as `--dedicated` if multiplayer)
4. warnings-as-errors pass: temporary `override.cfg` with `[debug] gdscript/warnings/untyped_declaration=2` (+ unsafe_*), rerun 2–3

`scripts/gate.sh` is a parametrized template (env: `GODOT`, `TEST_SCRIPT`, `SMOKE_ARGS`, `ALARM`). If the project already
has a gate (e.g. `tools/commit_gated.sh`), extend that one; don't add a second.

## Enforce it
- `.githooks/pre-push` → runs the gate `--check`. Opt-in: `git config core.hooksPath .githooks` (worktrees share it).
- Escape hatch: `SKIP_GATE=1 git push` — say why in the PR.
- CI runs the same script on Linux (install headless Godot first, checksum-verified).

## Limits — say them out loud
Headless cannot see rendering. A gate passes while the character judders at 144 fps. Pair with `godot-frame-rate-qa`
for anything visual, and never claim "tested" for a visual change from a headless pass.
