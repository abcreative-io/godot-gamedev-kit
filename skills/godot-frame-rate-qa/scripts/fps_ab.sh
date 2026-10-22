#!/bin/bash
# Replay one deterministic scene at several fixed frame rates (physics stays 60 Hz). Windowed; needs GPU + ffmpeg.
#   SCENE=res://tools/qa.tscn SCENE_ARGS="--seed 1" FPS_LIST="60 144" scripts/fps_ab.sh [out dir]
set -u
: "${SCENE:?set SCENE=res://path/to/scene.tscn}"
GODOT="${GODOT:-godot}"; FPS_LIST="${FPS_LIST:-60 144}"; RES="${RES:-1600x900}"
OUT="${1:-./fps-ab/$(date +%Y%m%d-%H%M)}"; rc=0
for fps in $FPS_LIST; do
  d="$OUT/fps$fps"; mkdir -p "$d"; echo "fps_ab: $fps -> $d"
  "$GODOT" --path . --resolution "$RES" --fixed-fps "$fps" --write-movie "$d/run.avi" "$SCENE" -- ${SCENE_ARGS:-} --out "$d" > "$d/log.txt" 2>&1 || rc=1
  grep -E "SCRIPT ERROR|^ERROR" "$d/log.txt" | head -10
  [ -f "$d/run.avi" ] && command -v ffmpeg >/dev/null && ffmpeg -nostdin -loglevel error -y -i "$d/run.avi" -c:v libx264 -crf 22 -pix_fmt yuv420p "$d/run.mp4" && rm -f "$d/run.avi"
done
echo "fps_ab: exit $rc — $OUT"; exit $rc
