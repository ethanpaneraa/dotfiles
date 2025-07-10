#!/bin/bash

# Enhanced aerospace.sh script for workspace highlighting
# Make sure it's executable with: chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/plugins/colors.sh"

# Get workspace ID from first argument
WORKSPACE_ID="$1"

# Get current focused workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --monitor 1 --visible)

# Check if this is the focused workspace
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  # This is the focused workspace - highlight it with pink background
  sketchybar --set "$NAME" background.color=$HIGHLIGHT_BACKGROUND label.color=$TEXT_WHITE icon.color=$TEXT_WHITE
else
  # Check if this workspace has any windows
  HAS_WINDOWS=$(aerospace list-workspaces --empty no | grep -c "^$WORKSPACE_ID$")

  if [ "$HAS_WINDOWS" -gt 0 ]; then
    # Non-visible workspace with windows - light background
    sketchybar --set "$NAME" background.color=$BACKGROUND label.color=$TEXT_GREY icon.color=$TEXT_GREY
  else
    # Empty workspace - transparent background
    sketchybar --set "$NAME" background.color=$TRANSPARENT label.color=$TEXT_GREY icon.color=$TEXT_GREY
  fi
fi

# Update the app icons for this workspace
apps=$(aerospace list-windows --workspace "$WORKSPACE_ID" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

icon_strip=" "
if [ "${apps}" != "" ]; then
  while read -r app; do
    icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
  done <<<"${apps}"
else
  icon_strip=""
fi

sketchybar --set "$NAME" label="$icon_strip"
