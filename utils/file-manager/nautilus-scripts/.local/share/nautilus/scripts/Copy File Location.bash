#!/usr/bin/env bash

# Get the file path of the selected item. 
# The NAUTILUS_SCRIPT_SELECTED_FILE_PATHS envirnment variable, set by Nautilus contains the full path of the selected files. 
#This is stored to the variable FULL_PATH.

declare -A messages=(
  [en.UTF-8.succ]="Full path to selected file is copied to your clipboard!"
  [lt_LT.UTF-8.succ]="Kelias iki pasirinkto failo nukopijuotas į iškarpinę!"
)

FULL_PATH="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# The file path in the variable FULL_PATH is copied to the clipboard using xclip.

echo -n "$FULL_PATH" | xclip -selection clipboard

# Use notify-send command to notify the user that the command has been copied to the clipboard.

notify-send "${messages[${LANG}.succ]}" "$FULL_PATH"
