#!/usr/bin/env bash

# convert ~/.config/i3/wallpaper.png -resize 10% -blur 0x6 -resize 500% ~/.config/i3/lockscreen.png

i3lock \
  -i ~/.config/i3/lockscreen.png \
  --nofork \
  --tiling \
  --ignore-empty-password \
  --show-failed-attempts
