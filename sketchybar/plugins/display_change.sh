#!/usr/bin/env bash

# This script handles display connection/disconnection events
# Add this to your plugins directory and make it executable with chmod +x display_change.sh

# First, remove all existing monitor-related items
sketchybar --remove '/monitor\..*/'
sketchybar --remove '/space\..*/'

# Add separators back
sketchybar --add item seperator.r1 left --set seperator.r1 padding_left=4 padding_right=4 background.drawing=off icon.drawing=off label.drawing=off

# Loop through all monitors and recreate workspace items
for monitor in $(aerospace list-monitors | awk '{print $1}'); do
  # Add monitor indicator
  sketchybar --add item monitor.$monitor left \
    --set monitor.$monitor \
    label="Monitor $monitor" \
    background.height=23 \
    background.corner_radius=5 \
    background.padding_right=5 \
    background.padding_left=5 \
    background.color=$BACKGROUND \
    background.drawing=on \
    icon.drawing=off \
    label.drawing=on \
    script="$PLUGIN_DIR/monitor_indicator.sh $monitor" \
    --subscribe monitor.$monitor aerospace_workspace_change display_change

  # Get workspaces for this monitor
  for sid in $(aerospace list-workspaces --monitor $monitor); do
    sketchybar --add item space.$monitor.$sid left \
      --subscribe space.$monitor.$sid aerospace_workspace_change display_change \
      --set space.$monitor.$sid \
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
      script="$PLUGIN_DIR/aerospace_multimonitor.sh $monitor $sid"
  done

  # Add separator between monitors
  if [ "$monitor" != "$(aerospace list-monitors | awk '{print $1}' | tail -1)" ]; then
    sketchybar --add item monitor.separator.$monitor left \
      --set monitor.separator.$monitor \
      padding_left=10 \
      padding_right=10 \
      background.drawing=off \
      icon="|" \
      icon.drawing=on \
      label.drawing=off
  fi
done

# Update all items
sketchybar --update
