#!/bin/bash

echo "Running sudo systemctl restart fprintd.service"
sudo systemctl restart fprintd.service
echo "Running hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'"
hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
echo "Running hyprctl --instance 0 'dispatch exec hyprlock'"
hyprctl --instance 0 'dispatch exec hyprlock'
