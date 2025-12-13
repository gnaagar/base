#!/bin/bash

choices="lock\nsuspend\nlogout\nreboot\nshutdown"
action=$(echo -e "$choices" | rofi -dmenu -p "action")

case "$action" in
  lock)
    loginctl lock-session ;;
  suspend)
    systemctl suspend ;;
  reboot)
    systemctl reboot ;;
  shutdown)
    systemctl poweroff ;;
  logout)
    i3-msg exit ;;
  *)
    exit 1 ;;
esac

