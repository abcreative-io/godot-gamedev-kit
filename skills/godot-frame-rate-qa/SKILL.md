---
name: godot-frame-rate-qa
description: Find and prove bugs that appear only at some frame rates or refresh rates in Godot 4 (judder, foot skating, camera/body stepping on high-refresh PCs while a 60 fps Mac looks fine). Use when something looks wrong on another machine, or after touching movement, camera, IK or animation code.
---

# Godot frame-rate QA

Dev machine at ~60 fps hides bugs that a 100–144 fps player sees. Physics ticks at 60 Hz (default) while rendering
runs faster, so anything read from a physics body in `_process` changes only every 2.4 frames at 144 fps.

## Checklist (read the code before running anything)
- `project.godot`: `run/max_fps`, `physics/common/physics_interpolation`, `physics/common/physics_ticks_per_second`, vsync.
- Nodes that follow a physics body: are they moved in `_process` (stepping) or interpolated? Camera rigs especially.
- Per-frame measures taken from a physics position (`moved = pos - last_pos` in `_process`) → zero on most frames, large
  on tick frames. Measure on physics ticks, or from an interpolated position.
- Teleports/spawns with interpolation on → call `reset_physics_interpolation()`.
- IK/SkeletonModifier3D that plants feet in world space against a stepping body → feet skate.

## Reproduce without the other machine
`scripts/fps_ab.sh` replays one deterministic scene with Godot's movie writer at several `--fixed-fps` values
(60 and 144) while physics stays at 60 Hz — exactly the mismatch. Env: `SCENE` (res:// path), `SCENE_ARGS`, `FPS_LIST`.
Compare metrics in **per second**, never per frame (a frame is a different length in each run). Gate: the 144 fps
run matches the 60 fps run within ~10 %.

## Fix order
1. Enable physics interpolation, then audit every `_process` mover riding a physics body.
2. Or draw from `Engine.get_physics_interpolation_fraction()`-interpolated position; do measurement on ticks.
3. Fps cap only as a stopgap; it hides the bug.
Prove with the A/B before/after. Headless runs can't see this: don't claim it's fixed without the A/B or a human look.
