#!/usr/bin/env bash
source "$HOME/.config/ml4w/scripts/ml4w-notification-handler"
APP_NAME="System"

hyprctl reload

notify_user --a "${APP_NAME}" \
            --s "Hyprland reloaded" \
