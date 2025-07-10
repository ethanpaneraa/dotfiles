#!/bin/bash

# A more effective simple_aerospace.sh script for highlighting workspaces
source "$CONFIG_DIR/plugins/colors.sh"

# Get workspace ID from argument
SID=$1
NAME="space.$SID"

# Check if this workspace is visible on any monitor
VISIBLE_WORKSPACES=$(aerospace list-workspaces --visible 2>/dev/null)
IS_VISIBLE=0

if echo "$VISIBLE_WORKSPACES" | grep -q "^$SID$"; then
  IS_VISIBLE=1
fi

# Check if this workspace has any windows
HAS_WINDOWS=0
if aerospace list-workspaces --empty no 2>/dev/null | grep -q "^$SID$"; then
  HAS_WINDOWS=1
fi

# Set appearance based on state
if [ $IS_VISIBLE -eq 1 ]; then
  # Highlighted if visible - PINK HIGHLIGHT
  sketchybar --set $NAME background.color=$HIGHLIGHT_BACKGROUND label.color=$TEXT_WHITE icon.color=$TEXT_WHITE
elif [ $HAS_WINDOWS -eq 1 ]; then
  # Medium highlight if has windows but not visible
  sketchybar --set $NAME background.color=$BACKGROUND label.color=$TEXT_GREY icon.color=$TEXT_GREY
else
  # Dim if empty
  sketchybar --set $NAME background.color=$TRANSPARENT label.color=$TEXT_GREY icon.color=$TEXT_GREY
fi

# Get app icons for this workspace
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
