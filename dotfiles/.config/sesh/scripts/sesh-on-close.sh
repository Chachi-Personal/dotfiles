#!/usr/bin/env bash
# Runs on tmux's `session-closed` hook (fires on kill/destroy, NOT on detach).
#
# tmux does not expose *which* session closed from inside this hook, so we
# reconcile: diff the previous alive-snapshot against the sessions that are
# still live. Any name present before but gone now just closed — run its
# per-project teardown script if one exists (scripts/<name>-stop.sh).
#
# This is the generic teardown dispatcher: add scripts/<session>-stop.sh for
# any future project and it works with no further wiring.
snap="$HOME/.cache/sesh/alive"
scripts="$HOME/.config/sesh/scripts"

now="$(mktemp)"
tmux list-sessions -F '#{session_name}' >"$now" 2>/dev/null

comm -23 <(sort -u "$snap" 2>/dev/null) <(sort -u "$now") | while read -r name; do
  [ -z "$name" ] && continue
  stop="$scripts/${name}-stop.sh"
  [ -x "$stop" ] && "$stop"
done

# Advance the snapshot so a subsequent close reconciles against current state.
mv -f "$now" "$snap"
