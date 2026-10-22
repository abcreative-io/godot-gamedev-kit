---
name: godot-stack-setup
description: Bootstrap or audit the agent workflow in a Godot 4 repo — what rules, process, gate, CI and skills exist, what is missing, and installing only the skills worth having. Use when starting a new Godot project or when asked to "set up the stack".
---

# Godot stack setup

Audit first, add second. Most repos already have part of this; duplicating it creates two workflows that fight.

## 1. Audit (report before changing anything)
Check and list what exists: `CLAUDE.md`/`AGENTS.md` (size, hard rules), a spec/process layer (e.g. Spec Kit `speckit-*`),
a commit gate (`tools/*gate*`), tests runner, CI (`.github/workflows`), `.claude/skills`, `.claude/settings.json` hooks,
how the project is run headless (`godot --headless --path . --quit-after N`), target platforms, and which machine
QA runs on. Name the gap in one line each.

## 2. Fill gaps only
- No gate → `godot-commit-gate`. Gate exists but only by convention → add the opt-in pre-push hook (see that skill).
- Visual bug only on some machines/refresh rates → `godot-frame-rate-qa`.
- Character looks wrong → `godot-character-visual-qa`.
- Process layer: if the repo already has a spec workflow, do NOT add a second (Pocock `to-spec`/`to-tickets`/`implement`).

## 3. Optional generic engineering skills (Matt Pocock)
`npx skills@latest add mattpocock/skills -a claude-code -y --copy` installs ALL ~38 skills whatever `--skill` says.
Then delete the extras by hand, keep: `tdd` (+`codebase-design`), `diagnosing-bugs`, `code-review`, `pr`,
`setup-matt-pocock-skills`. Rules learned the hard way:
- Delete only UNTRACKED new folders (`git ls-files --error-unmatch <dir>` fails → safe to `rm -rf`).
- Never run `npx skills remove` in a repo with tracked skills: it removed tracked ones. Restore with `git checkout`.
- Prune `skills-lock.json` to the kept skills.
- `/setup-matt-pocock-skills` is manual-invoke and interactive; give the user a prefilled prompt, don't run it for them.

## 4. Keep `CLAUDE.md` lean
It loads every turn. Hard rules and run commands stay; long pipelines move into skills (loaded only when relevant).
