#!/bin/bash

# This script updates workspace icons when windows change
# Use: sketchybar --trigger workspace_update

source "$CONFIG_DIR/plugins/colors.sh"

# Define workspaces to check
WORKSPACES="1 2 3 4 5 6 7 8 9 10"

# Get current workspace from aerospace
CURRENT_WORKSPACE=""
for monitor in $(aerospace list-monitors --all | awk '{print $1}'); do
  VISIBLE=$(aerospace list-workspaces --monitor $monitor --visible 2>/dev/null)
  if [ -n "$VISIBLE" ]; then
    # If this is the focused monitor, this is our current workspace
    IS_FOCUSED=$(aerospace list-monitors --focused | grep "^$monitor" | wc -l)
    if [ "$IS_FOCUSED" -gt 0 ]; then
      CURRENT_WORKSPACE="$VISIBLE"
    fi
  fi
done

# Update all workspaces
for sid in $WORKSPACES; do
  # Get windows in this workspace
  WINDOWS=$(aerospace list-windows --workspace $sid 2>/dev/null | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  # Build icon strip
  icon_strip=" "
  if [ -n "$WINDOWS" ]; then
    while read -r app; do
      [ -n "$app" ] && icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<<"$WINDOWS"
  else
    icon_strip=""
  fi

  # Check if this is the current workspace
  if [ "$sid" = "$CURRENT_WORKSPACE" ]; then
    # Highlight current workspace
    sketchybar --set space.$sid background.color=0x35ffffff label.color=$TEXT_WHITE icon.color=$TEXT_WHITE label="$icon_strip"
  else
    # Non-current workspace
    if [ -n "$WINDOWS" ]; then
      # Has windows
      sketchybar --set space.$sid background.color=0x20ffffff label.color=$TEXT_GREY icon.color=$TEXT_GREY label="$icon_strip"
    else
      # Empty workspace
      sketchybar --set space.$sid background.color=0x10ffffff label.color=$TEXT_GREY icon.color=$TEXT_GREY label="$icon_strip"
    fi
  fi
done
