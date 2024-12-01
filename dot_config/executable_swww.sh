#!/bin/bash

wallpaper="$HOME/.config/wallpaper.png"

magick "$wallpaper" -coalesce -repage 0x0 -crop 3325x1870+0+0 +repage /tmp/left.png
magick "$wallpaper" -coalesce -repage 0x0 -crop 2355x1331+3325+813 +repage /tmp/right.png

swww img -o HDMI-A-1 /tmp/left.png
swww img -o DVI-D-1 /tmp/right.png
