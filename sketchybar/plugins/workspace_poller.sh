#!/bin/bash

# This script runs in the background and periodically updates the workspace status
# Kill any existing instances first
pgrep -f "workspace_poller" | grep -v $$ | xargs kill 2>/dev/null

while true; do
  "$CONFIG_DIR/plugins/update_workspace_icons.sh" >/dev/null 2>&1
  sleep 2
done
