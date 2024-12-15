#!/bin/bash

filename="UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

eww update current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id')

socat -U - $filename | while read -r line; do
  current_workspace="$(echo $line | awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}')"

  if [ $current_workspace ]; then
    eww update current_workspace=$current_workspace
  fi
done
