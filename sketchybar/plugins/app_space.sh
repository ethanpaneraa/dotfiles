#!/bin/sh

source "$HOME/.config/colors.sh"
source "$HOME/.config/icons.sh"

sketchybar --set $NAME background.drawing=$SELECTED \
    icon.highlight=$SELECTED \
    label.highlight=$SELECTED

# This script now shows application icons in each workspace
for i in "${!ICONS_SPACE[@]}"
do
    sid=$(($i + 1))
    LABEL=""
    
    # Query aerospace for windows in this workspace
    QUERY=$(aerospace list-windows --workspace $sid --format "%{app-name}" 2>/dev/null)
    
    if [[ -n "$QUERY" ]]; then
        APPS_ARR=()
        while IFS= read -r line; do 
            if [[ -n "$line" ]]; then
                APPS_ARR+=("$line")
            fi
        done <<< "$QUERY"
        
        LENGTH=${#APPS_ARR[@]}
        for j in "${!APPS_ARR[@]}"
        do
            APP="${APPS_ARR[j]}"
            ICON=$("/Users/$(whoami)/.config/sketchybar/plugins/app_icon.sh" "$APP" "")
            LABEL+=" $ICON "
            if [[ $j < $(($LENGTH-1)) ]]; then
                LABEL+=" "
            fi
        done
    else
        LABEL+=""
    fi
    
    sketchybar --set space.$sid label="$LABEL"
done
