#!/bin/bash

echo $(bspc query -D -d focused --names)

bspc subscribe desktop | while read -r _; do
  echo $(bspc query -D -d focused --names)
done

