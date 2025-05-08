#!/bin/bash

options="Shutdown\nReboot\nLogout"
choice=$(echo -e "$options" | fuzzel --dmenu)
case "$choice" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Logout) swaymsg exit ;;
esac

