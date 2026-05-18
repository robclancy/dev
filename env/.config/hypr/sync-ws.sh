#!/usr/bin/env bash
FOCUSED=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')

hyprctl dispatch focusmonitor DP-1
hyprctl dispatch workspace "$1"
hyprctl dispatch focusmonitor DP-2
hyprctl dispatch workspace "$2"
hyprctl dispatch focusmonitor "$FOCUSED"

