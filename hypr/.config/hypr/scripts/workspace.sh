#!/bin/bash

focus() {
  local ws=$1
  
  local CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.name')
  local CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')

  local TARGET_WS=$1
  local MONITOR_WITH_TARGET=$(hyprctl workspaces -j | jq -r '.[] | select(.name=="'"$TARGET_WS"'") | .monitor')
  local ACTIVE_WS_ON_TARGET_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.name=="'"$MONITOR_WITH_TARGET"'") | .activeWorkspace.id')

  if [ "$CURRENT_WS" == "$TARGET_WS" ]; then
      echo "Already focused on WS: $TARGET_WS"
      exit 0
  fi

  if [ -z "$MONITOR_WITH_TARGET" ]; then
      hyprctl dispatch workspace "$TARGET_WS"
      echo "Switched to WS: $TARGET_WS"
      exit 0
  fi

  if [ "$ACTIVE_WS_ON_TARGET_MONITOR" != "$TARGET_WS" ]; then
      hyprctl dispatch moveworkspacetomonitor "$TARGET_WS" "$CURRENT_MONITOR"
      hyprctl dispatch workspace "$TARGET_WS"
      exit 0
  fi

  echo "Moving $TARGET_WS to $CURRENT_MONITOR"
  hyprctl dispatch moveworkspacetomonitor "$TARGET_WS" "$CURRENT_MONITOR"

  echo "Moving $CURRENT_WS to $MONITRO_WITH_TARGET"
  hyprctl dispatch moveworkspacetomonitor "$CURRENT_WS" "$MONITOR_WITH_TARGET"
  # hyprctl dispatch focusmonitor "$CURRENT_MONITOR"

  hyprctl dispatch focusmonitor "$CURRENT_MONITOR"
  ACTIVE_WS_ON_CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.name=="'"$CURRENT_MONITOR"'") | .activeWorkspace.id')
  if [ "$ACTIVE_WS_ON_CURRENT_MONITOR" != "$TARGET_WS" ]; then
      hyprctl dispatch workspace "$TARGET_WS"
      exit 0
  fi
}

move() {
  local CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')
  hyprctl dispatch movetoworkspace "$1"
  hyprctl dispatch moveworkspacetomonitor "$1" "$CURRENT_MONITOR"
}

case "$1" in
  focus) 
    focus $2
  ;;
  move) 
    move $2
  ;;
  *) 
    echo default
  ;;
esac

