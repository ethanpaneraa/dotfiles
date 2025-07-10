#!/usr/bin/env bash

# A lightweight script to handle workspace items
# Argument: $1 = workspace ID (sid)

SID=$1
NAME=$(sketchybar --query "space.$SID" | jq -r '.name')

# Get all visible workspaces across all monitors
VISIBLE_WORKSPACES=$(aerospace list-workspaces --visible | tr '\n' ' ')

# Check if this workspace is visible on any monitor
if [[ $VISIBLE_WORKSPACES == *"$SID"* ]]; then
  # This workspace is currently visible - highlight it
  sketchybar --set $NAME background.color=0x35ffffff
else
  # This workspace is not visible
  # Check if it has any windows
  HAS_WINDOWS=$(aerospace list-workspaces --empty no | grep -c "^$SID$")

  if [ "$HAS_WINDOWS" -gt 0 ]; then
    # Non-visible workspace with windows - standard background
    sketchybar --set $NAME background.color=0x20ffffff
  else
    # Empty workspace - subtle background
    sketchybar --set $NAME background.color=0x10ffffff
  fi
fi

# Update the label with app icons if there are any windows
apps=$(aerospace list-windows --workspace "$SID" 2>/dev/null | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

icon_strip=" "
if [ "${apps}" != "" ]; then
  # Limit the number of app icons to prevent performance issues
  count=0
  max_icons=3

  while read -r app && [ $count -lt $max_icons ]; do
    icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    count=$((count+1))
  done <<<"${apps}"

  # Add an ellipsis if there are more apps than we're showing
  if [ $(wc -l <<<"${apps}") -gt $max_icons ]; then
    icon_strip+=" ..."
  fi
else
  icon_strip=""
fi

sketchybar --set $NAME label="$icon_strip"
