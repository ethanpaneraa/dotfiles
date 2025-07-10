#!/bin/bash

# Enhanced function to properly refresh spaces
refresh_spaces() {
  echo "Refreshing spaces and windows..." >> /tmp/sketchybar_debug.log

  # First, clear all existing spaces
  for space in $(sketchybar --query items | grep "space\." | cut -d'.' -f2); do
    sketchybar --remove space.$space 2>/dev/null
  done

  # Then recreate all spaces based on current aerospace state
  for sid in $(aerospace list-workspaces); do
    sketchybar --add item space.$sid left \
      --subscribe space.$sid aerospace_workspace_change window_change window_focus \
      --set space.$sid \
      drawing=off \
      background.corner_radius=5 \
      background.drawing=on \
      background.border_width=1 \
      background.height=23 \
      background.padding_right=5 \
      background.padding_left=5 \
      icon="$sid" \
      icon.shadow.drawing=off \
      icon.padding_left=10 \
      label.font="sketchybar-app-font:Regular:16.0" \
      label.padding_right=20 \
      label.padding_left=0 \
      label.y_offset=-1 \
      label.shadow.drawing=off \
      click_script="aerospace workspace $sid" \
      script="$CONFIG_DIR/plugins/aerospace.sh $sid"
  done

  # Update the app icons for all spaces
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
}

# Export the function so it can be called from other scripts
export -f refresh_spaces
