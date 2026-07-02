#!/usr/bin/env bash
# Snapshot the currently-alive tmux sessions to a file, atomically.
# Wired to tmux's `session-created` hook so the snapshot always reflects the
# set of live sessions. sesh-on-close.sh diffs against this to learn which
# session just vanished (tmux can't tell you that from inside session-closed).
snap="$HOME/.cache/sesh/alive"
mkdir -p "$(dirname "$snap")"
tmp="$(mktemp "${snap}.XXXXXX")"
tmux list-sessions -F '#{session_name}' >"$tmp" 2>/dev/null
mv -f "$tmp" "$snap"
