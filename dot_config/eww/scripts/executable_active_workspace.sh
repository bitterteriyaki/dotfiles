#!/bin/bash

filename="UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

eww update current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id')

socat -U - $filename | while read -r line; do
  eww update current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id')
done
