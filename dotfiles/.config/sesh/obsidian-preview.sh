#!/usr/bin/env bash
# Preview for the "obsidian" sesh session.
# sesh runs preview_command without a shell (no ;, &&, or pipes),
# so command chaining lives here instead. $1 is the session path.
figlet "Obsidian Vault"
eza --all --git --icons --color=always "$1"
