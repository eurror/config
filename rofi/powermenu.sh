#!/usr/bin/env bash

chosen=$(echo -e "󰍃 Lock\n󰗼 Logout\n󰜉 Reboot\n⏻ Shutdown" \
  | rofi -dmenu -i -p " System Action" \
    -theme-str 'window {location: center;}')

case "$chosen" in
  "󰍃 Lock") i3lock -c 04090e ;;
  "󰗼 Logout") i3-msg exit ;;
  "󰜉 Reboot") systemctl reboot ;;
  "⏻ Shutdown") systemctl poweroff ;;
esac
