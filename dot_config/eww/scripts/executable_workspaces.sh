#!/bin/bash

filename="UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

hyprctl workspaces -j | jq -c 'sort_by(.id)'

socat -U - $filename | while read; do
  hyprctl workspaces -j | jq -c 'sort_by(.id)'
done
