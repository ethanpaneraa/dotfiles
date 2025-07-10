#!/bin/bash

# Define a custom event that will be called when monitors change
sketchybar --add event monitor_change

# Function to get the current monitor count and hash
get_monitor_state() {
  system_profiler SPDisplaysDataType | grep -e "Resolution" -e "Connection Type" | sort | md5
}

# Get initial state
LAST_STATE=$(get_monitor_state)

# Monitor for changes
while true; do
  sleep 5
  CURRENT_STATE=$(get_monitor_state)

  if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
    echo "Monitor change detected, triggering refresh" >> /tmp/sketchybar_debug.log
    LAST_STATE=$CURRENT_STATE

    # Give the system a moment to settle after display change
    sleep 2

    # Trigger the event
    sketchybar --trigger monitor_change
  fi
done
