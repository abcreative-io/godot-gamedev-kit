---
name: godot-character-visual-qa
description: Diagnose a Godot 4 character that looks wrong (run cycle, stature, legs, foot slide, pops, jitter) by measuring each layer that writes bones instead of guessing. Use when a character's animation or proportions look off, especially on one platform.
---

# Godot character visual QA

Never edit retarget, IK or animation from a hunch. Find the layer that writes the bad pose.

## 1. Get evidence
A screenshot or clip from the machine where it looks wrong, plus: OS, GPU, fps, graphics preset, resolution/aspect.
No evidence → say so and ask; don't change anything.

## 2. Is it timing or pose?
Timing (judder, skating, camera/body stepping): run `godot-frame-rate-qa` first. Pose (wrong proportions, bent knees,
twisted legs, T-pose): continue.

## 3. Measure per layer
Pose stack, bottom to top: raw clip → retarget → overlays/procedural code → each `SkeletonModifier3D` (IK, look-at, lean).
Record the same metric after each layer and toggle layers off (modifier `influence = 0`) to see which one introduces the error.
Metrics: planted-foot slide (cm/s), knee angle vs foot, ankle spread, hips bob, frame-to-frame max bone turn (pops),
hand through torso, head pitch/roll.

## 4. Proportions
Check scale sources in this order: import scale and skeleton rest pose, per-age/per-character scaling data, retarget
bone-map and rest-pose offset, stride vs leg length (stride too long for the legs = foot skate), camera FOV and lens.

## 5. Report
Before/after still pair + the metric table + the layer that changed. Record the decision in the project's decision log.
