#!/bin/bash

# Updated space_windows.sh script for multi-monitor setups
# This script handles window icons for all workspaces across all monitors

# First mark all spaces as hidden
for sid in $(aerospace list-workspaces); do
  sketchybar --set space.$sid drawing=off
done

# Show and update icons for all non-empty workspaces across all monitors
for sid in $(aerospace list-workspaces --empty no); do
  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  sketchybar --set space.$sid drawing=on

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app; do
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<<"${apps}"
  else
    icon_strip=""
  fi
  sketchybar --set space.$sid label="$icon_strip"
done

# Also make sure visible workspaces are always showing, even if empty
for sid in $(aerospace list-workspaces --visible); do
  sketchybar --set space.$sid drawing=on
done
