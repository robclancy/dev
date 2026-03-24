#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

state="$1"
session_id=$(jq -r '.session_id // "unknown"')
state_file="/tmp/claude_bar_${session_id}"

# Walk up to find the claude process PID
claude_pid=""
pid=$PPID
for _ in 1 2 3 4; do
    name=$(ps -o comm= -p "$pid" 2>/dev/null | tr -d ' ')
    echo "$name" | grep -qi "claude" && claude_pid="$pid" && break
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    [ -z "$pid" ] || [ "$pid" -le 1 ] && break
done

if [ "$state" = "responding" ]; then
    instance=$(for d in /tmp/hypr/*/; do
        [ -S "${d}.socket.sock" ] && basename "$d" && break
    done)
    [ -z "$instance" ] && instance=$(for d in "$XDG_RUNTIME_DIR/hypr"/*/; do
        [ -S "${d}.socket.sock" ] && basename "$d" && break
    done)
    window_addr=$(hyprctl -i "$instance" activewindow -j 2>/dev/null | jq -r '.address // ""' 2>/dev/null)
else
    window_addr=""
    [ -f "$state_file" ] && IFS='|' read -r _ _ window_addr _ < "$state_file"
fi

echo "${state}|$(date +%s)|${window_addr}|${claude_pid}|${TMUX_PANE:-}" > "$state_file"
