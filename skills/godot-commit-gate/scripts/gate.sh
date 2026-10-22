#!/bin/bash
# Parametrized Godot gate. Run from the project root.  GODOT=godot TEST_SCRIPT=tests/run_tests.gd tools/gate.sh
set -u
GODOT="${GODOT:-godot}"; TEST_SCRIPT="${TEST_SCRIPT:-tests/run_tests.gd}"; SMOKE_ARGS="${SMOKE_ARGS:-}"; ALARM="${ALARM:-300}"
run() { perl -e 'alarm shift; exec @ARGV' "$ALARM" "$GODOT" --headless --path . "$@"; }
LOGS="$(mktemp -d)"; fail=0
run --import > "$LOGS/import.log" 2>&1
run --script "$TEST_SCRIPT" > "$LOGS/tests.log" 2>&1; rc=$?
grep -E "passed|FAIL" "$LOGS/tests.log"
{ [ $rc -ne 0 ] || grep -q "SCRIPT ERROR" "$LOGS/tests.log"; } && { echo "GATE: tests failed (exit $rc)"; fail=1; }
run --quit-after 180 -- $SMOKE_ARGS > "$LOGS/smoke.log" 2>&1; rc=$?
n=$(grep -cE "SCRIPT ERROR|ERROR" "$LOGS/smoke.log"); echo "smoke exit $rc, $n error lines"
{ [ $rc -ne 0 ] || [ "$n" -ne 0 ]; } && { grep -E -A3 "SCRIPT ERROR|ERROR" "$LOGS/smoke.log" | head -20; fail=1; }
cat > override.cfg <<'CFG'
[debug]
gdscript/warnings/untyped_declaration=2
gdscript/warnings/unsafe_property_access=2
gdscript/warnings/unsafe_method_access=2
gdscript/warnings/unsafe_call_argument=2
CFG
run --quit-after 180 -- $SMOKE_ARGS > "$LOGS/warn.log" 2>&1; r1=$?
run --script "$TEST_SCRIPT" >> "$LOGS/warn.log" 2>&1; r2=$?
rm -f override.cfg
w=$(grep -c "Warning treated as error" "$LOGS/warn.log"); echo "warnings pass: $r1/$r2, $w warnings"
{ [ $r1 -ne 0 ] || [ $r2 -ne 0 ] || [ "$w" -ne 0 ]; } && fail=1
[ $fail -ne 0 ] && { echo "GATE FAIL (logs $LOGS)"; exit 1; }
echo "GATE PASS"
