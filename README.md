# godot-gamedev-kit

Claude Code plugin: a Godot 4 game-dev stack you can drop into any project.

| Skill | Use |
|---|---|
| `godot-stack-setup` | Audit a repo, fill only the gaps, install only the generic skills worth having |
| `godot-commit-gate` | Hard headless gate (import, tests, smoke, warnings-as-errors) + opt-in pre-push hook |
| `godot-frame-rate-qa` | Reproduce "looks wrong on a 144 Hz PC" on a 60 fps machine (`scripts/fps_ab.sh`) |
| `godot-character-visual-qa` | Find which pose layer breaks a character, with evidence first |

## Install
```
claude plugin marketplace add ~/Claude/Projects/godot-gamedev-kit
claude plugin install godot-gamedev-kit@godot-gamedev-kit
```
Then in a Godot repo: ask "run the godot-stack-setup audit".

Generic only. Project-specific skills (art pipeline, weekly gate, the project's own QA harness) stay in each repo.
Not bundled: Matt Pocock's skills (install via `npx skills`, see `godot-stack-setup`).
