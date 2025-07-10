#!/usr/bin/env bash

# This script updates the monitor indicator
# Arguments: $1 = monitor number

MONITOR=$1
NAME=$(sketchybar --query "monitor.$MONITOR" | jq -r '.name')

# Get current focused monitor
FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')

# Get workspace for the specified monitor
CURRENT_WORKSPACE=$(aerospace list-workspaces --monitor $MONITOR --visible)

# Update monitor indicator
if [ "$MONITOR" = "$FOCUSED_MONITOR" ]; then
  # This is the active monitor - highlight it
  sketchybar --set $NAME label="Monitor $MONITOR → $CURRENT_WORKSPACE" background.color=0x35ffffff
else
  # Non-active monitor - subtle appearance
  sketchybar --set $NAME label="Monitor $MONITOR → $CURRENT_WORKSPACE" background.color=0x20ffffff
fi
