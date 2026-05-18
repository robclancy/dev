#!/usr/bin/env bash
FOCUSED_MON=$(hyprctl activewindow -j | jq -r '.monitor')
FOCUSED_MON_NAME=$(hyprctl monitors -j | jq -r ".[] | select(.id==$FOCUSED_MON) | .name")

if [ "$FOCUSED_MON_NAME" = "DP-1" ]; then
    hyprctl dispatch movetoworkspacesilent "$1"
else
    hyprctl dispatch movetoworkspacesilent "$2"
fi
