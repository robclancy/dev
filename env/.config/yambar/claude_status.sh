#!/bin/bash

now=$(date +%s)
current_addr=$(hyprctl activewindow -j 2>/dev/null | jq -r '.address // ""')
states=()
labels=()

for state_file in $(ls /tmp/claude_bar_* 2>/dev/null | sort); do
    [ -f "$state_file" ] || continue

    IFS='|' read -r state timestamp window_addr claude_pid pane_id < "$state_file"

    # Clean up dead sessions
    if [ -n "$pane_id" ]; then
        # tmux session: check if the pane still exists
        if ! tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qx "$pane_id"; then
            rm -f "$state_file"
            continue
        fi
    elif [ -n "$claude_pid" ] && ! kill -0 "$claude_pid" 2>/dev/null; then
        # non-tmux: check if process is still alive
        rm -f "$state_file"
        continue
    fi

    # Fallback: ignore files older than 1 hour with no session info
    file_mtime=$(stat -c %Y "$state_file")
    [ -z "$pane_id" ] && [ -z "$claude_pid" ] && [ $((now - file_mtime)) -gt 3600 ] && continue

    case "$state" in
        responding)
            age=$((now - timestamp))
            elapsed=$(printf "%d:%02d" $((age / 60)) $((age % 60)))
            states+=("responding")
            labels+=("CC $elapsed")
            ;;
        permission)
            states+=("permission")
            labels+=("CC*")
            ;;
        needs_attention)
            if [ -n "$window_addr" ] && [ "$current_addr" != "$window_addr" ]; then
                echo "needs_attention_left|${timestamp}|${window_addr}|${claude_pid}" > "$state_file"
            fi
            states+=("needs_attention")
            labels+=("CC*")
            ;;
        needs_attention_left)
            if [ -n "$window_addr" ] && [ "$current_addr" = "$window_addr" ]; then
                echo "seen|${timestamp}|${window_addr}|${claude_pid}" > "$state_file"
                states+=("seen")
                labels+=("CC ·")
            else
                states+=("needs_attention")
                labels+=("CC*")
            fi
            ;;
        seen)
            states+=("seen")
            labels+=("CC ·")
            ;;
    esac
done

for i in 0 1 2 3 4; do
    if [ $i -lt ${#states[@]} ]; then
        echo "s${i}|string|${states[$i]}"
        echo "s${i}e|string|${labels[$i]}"
    else
        echo "s${i}|string|idle"
        echo "s${i}e|string|"
    fi
done

[ ${#states[@]} -gt 0 ] && echo "any|bool|true" || echo "any|bool|false"

echo ""
