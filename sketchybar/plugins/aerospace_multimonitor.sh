#!/usr/bin/env bash

# This script handles the workspace item states for multi-monitor support
# Arguments: $1 = monitor number, $2 = workspace ID

MONITOR=$1
SID=$2
NAME=$(sketchybar --query "space.$MONITOR.$SID" | jq -r '.name')

# Get current focused monitor
FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')

# Get current workspace for the specified monitor
CURRENT_WORKSPACE=$(aerospace list-workspaces --monitor $MONITOR --visible)

# If this is the focused monitor and the current workspace
if [ "$MONITOR" = "$FOCUSED_MONITOR" ] && [ "$SID" = "$CURRENT_WORKSPACE" ]; then
  # Highlight active workspace on active monitor
  sketchybar --set $NAME background.color=0x35ffffff label.drawing=on
else
  # Check if this workspace has windows
  HAS_WINDOWS=$(aerospace list-workspaces --monitor $MONITOR --empty no | grep -c "^$SID$")

  if [ "$HAS_WINDOWS" -gt 0 ]; then
    # Non-active workspace with windows - show with default background
    sketchybar --set $NAME background.color=0x20ffffff label.drawing=on
  else
    # Empty workspace - more subtle appearance
    sketchybar --set $NAME background.color=0x10ffffff label.drawing=off
  fi
fi

# Update the label with app icons if any
apps=$(aerospace list-windows --workspace "$SID" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

icon_strip=" "
if [ "${apps}" != "" ]; then
  while read -r app; do
    icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
  done <<<"${apps}"
else
  icon_strip=""
fi

sketchybar --set $NAME label="$icon_strip"
