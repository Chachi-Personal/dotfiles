#!/usr/bin/env bash
# Startup for the "bambuk" sesh session.
# Analog of tmuxinator's on_project_first_start / on_project_restart.
# sesh runs this in the session's first pane, so it ends by exec'ing the editor.
set -euo pipefail

# cd "$HOME/Documents/code/work/bambuk" || exit 1

# Bring up the Laravel Sail containers. `up -d` is idempotent, so this is safe
# on both the first start and every restart.
./vendor/bin/sail up -d || true

# Match the tmuxinator layout: a single window named "editor" running the editor.
tmux rename-window editor 2>/dev/null || true

clear || true

# exec nvim
