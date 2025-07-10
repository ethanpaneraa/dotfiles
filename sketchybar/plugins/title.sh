#!/bin/bash

# Get app name and window title from aerospace
APP_NAME=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null)
WINDOW_TITLE=$(aerospace list-windows --focused --format "%{name}" 2>/dev/null)

if [[ -z "$APP_NAME" ]]; then
  APP_NAME="Desktop"
  UNICODE_ICON="󰪶"  # Default icon for desktop
else
  # Get the icon using the icon map function (which returns :icon_name: format)
  APP_ICON=$($CONFIG_DIR/plugins/icon_map_fn.sh "$APP_NAME")

  # Convert :icon_name: format to Unicode icon
  case "$APP_ICON" in
    ":firefox:")
      UNICODE_ICON="󰈹"
      ;;
    ":safari:")
      UNICODE_ICON="󰀹"
      ;;
    ":terminal:")
      UNICODE_ICON="󰆍"
      ;;
    ":code:")
      UNICODE_ICON="󰨞"
      ;;
    ":finder:")
      UNICODE_ICON="󰀶"
      ;;
    ":google_chrome:")
      UNICODE_ICON="󰊯"
      ;;
    ":discord:")
      UNICODE_ICON="󰙯"
      ;;
    ":spotify:")
      UNICODE_ICON="󰓇"
      ;;
    ":slack:")
      UNICODE_ICON="󰒱"
      ;;
    ":mail:")
      UNICODE_ICON="󰇮"
      ;;
    ":iterm:")
      UNICODE_ICON="󰆍"
      ;;
    ":warp:")
      UNICODE_ICON="󰞷"
      ;;
    ":arc:")
      UNICODE_ICON="󰊯"
      ;;
    ":brave_browser:")
      UNICODE_ICON="󰗃"
      ;;
    ":notion:")
      UNICODE_ICON="󰈙"
      ;;
    ":vscode:")
      UNICODE_ICON="󰨞"
      ;;
    ":obsidian:")
      UNICODE_ICON="󰿘"
      ;;
    *)
      UNICODE_ICON="󰘔"  # Generic app icon
      ;;
  esac
fi

# Combine window title with app name if available
if [[ -n "$WINDOW_TITLE" && "$WINDOW_TITLE" != "$APP_NAME" ]]; then
  DISPLAY_TEXT="$APP_NAME - $WINDOW_TITLE"
else
  DISPLAY_TEXT="$APP_NAME"
fi

# Set the title with both icon and app name
sketchybar --set title icon="$UNICODE_ICON" label="$DISPLAY_TEXT"

# Log for debugging
echo "$(date): App=$APP_NAME, AppIcon=$APP_ICON, UniIcon=$UNICODE_ICON" >> /tmp/sketchybar_debug.log
