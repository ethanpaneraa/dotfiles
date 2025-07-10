#!/bin/bash

# This script acts as a wrapper for all workspace-related events
# It triggers the update for all workspace indicators

# Get focused monitor and visible workspace
FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
FOCUSED_WORKSPACE=$(aerospace list-workspaces --monitor $FOCUSED_MONITOR --visible)

# Update all workspace items
for sid in $(aerospace list-workspaces); do
  # Run the aerospace.sh script for each workspace to update its appearance
  "$CONFIG_DIR/plugins/aerospace.sh" "$sid"
done

# Optionally, update window icons as well
"$CONFIG_DIR/plugins/update_workspace_icons.sh"

# Log for debugging
echo "$(date): Workspace change detected - Current workspace: $FOCUSED_WORKSPACE" >> /tmp/sketchybar_workspace.log
