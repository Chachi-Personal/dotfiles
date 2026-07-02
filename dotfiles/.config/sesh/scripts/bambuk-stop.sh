#!/usr/bin/env bash
# Teardown for the "bambuk" sesh session.
# Analog of tmuxinator's on_project_stop. Invoked by sesh-on-close.sh when the
# bambuk tmux session is destroyed (killed) — NOT when you merely detach.
set -euo pipefail

cd "$HOME/Documents/code/work/bambuk" || exit 1

./vendor/bin/sail down
