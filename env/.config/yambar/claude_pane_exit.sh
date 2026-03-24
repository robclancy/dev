#!/bin/bash
# Called by tmux pane-exited hook. Removes state files for the closed pane.
pane_id="$1"
[ -z "$pane_id" ] && exit 0
for f in /tmp/claude_bar_*; do
    [ -f "$f" ] || continue
    IFS='|' read -r _ _ _ _ p < "$f"
    [ "$p" = "$pane_id" ] && rm -f "$f"
done
