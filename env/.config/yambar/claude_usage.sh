#!/bin/bash
# Get Claude Code usage stats by running a headless claude session

output=""
short_pct=""
long_pct=""
short_reset=""
long_reset=""

claude_cmd() {
    local cmd="$1"
    mkfifo /tmp/claude_cmds_$$ 2>/dev/null || return 1
    
    # Send commands with delays
    (
        sleep 5
        printf "%s\r" "$cmd"
        sleep 5
        printf "q\r"
        sleep 2
        printf "/exit\r"
    ) > /tmp/claude_cmds_$$ &
    
    timeout 35 script -q -c 'claude --bare' /dev/null < /tmp/claude_cmds_$$ 2>&1
    rm -f /tmp/claude_cmds_$$
}

if command -v claude &>/dev/null && command -v script &>/dev/null; then
    
    # Try /usage first
    usage_output=$(claude_cmd "/usage")
    
    if [ -n "$usage_output" ]; then
        # Strip ANSI codes
        clean_output=$(echo "$usage_output" | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | tr -s ' ')
        
        # Look for percentage used patterns (e.g., "14% used")
        pct_lines=$(echo "$clean_output" | grep -oE '[0-9]+%[[:space:]]*used')
        
        if [ -n "$pct_lines" ]; then
            short_pct=$(echo "$pct_lines" | head -1 | grep -oE '[0-9]+')
            long_pct=$(echo "$pct_lines" | tail -1 | grep -oE '[0-9]+')
        fi
        
        # Look for reset patterns
        reset_lines=$(echo "$clean_output" | grep -i 'resets')
        if [ -n "$reset_lines" ]; then
            short_reset=$(echo "$reset_lines" | head -1 | sed -E 's/.*Resets[[:space:]]*//i' | sed 's/(.*)//' | tr -s ' ' | cut -c1-20)
            long_reset=$(echo "$reset_lines" | tail -1 | sed -E 's/.*Resets[[:space:]]*//i' | sed 's/(.*)//' | tr -s ' ' | cut -c1-20)
        fi
    fi
    
    # If no data, try /stats as fallback
    if [ -z "$short_pct" ] && [ -z "$long_pct" ]; then
        stats_output=$(claude_cmd "/stats")
        if [ -n "$stats_output" ]; then
            clean_stats=$(echo "$stats_output" | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | tr -s ' ')
            
            # Look for total tokens to estimate usage
            total_tokens=$(echo "$clean_stats" | grep -oE 'Totaltokens:[^[:space:]]+' | head -1)
            if [ -n "$total_tokens" ]; then
                short_pct="stats"
            fi
        fi
    fi
    
    # Build output string
    if [ -n "$short_pct" ] && [ -n "$long_pct" ]; then
        output="S:${short_pct}% L:${long_pct}%"
        [ -n "$short_reset" ] && output="$output (${short_reset})"
    elif [ -n "$short_pct" ]; then
        output="${short_pct}%"
        [ -n "$short_reset" ] && output="$output (${short_reset})"
    fi
fi

# Final fallback: show subscription type
if [ -z "$output" ]; then
    creds_file="$HOME/.claude/.credentials.json"
    if [ -f "$creds_file" ]; then
        sub_type=$(jq -r '.claudeAiOauth.subscriptionType // ""' "$creds_file" 2>/dev/null)
        [ -n "$sub_type" ] && output="CC ${sub_type}"
    fi
fi

echo "usage|string|${output}"
echo "short|string|${short_pct}"
echo "long|string|${long_pct}"
echo "short_reset|string|${short_reset}"
echo "long_reset|string|${long_reset}"
echo "has_usage|bool|$([ -n "$output" ] && echo true || echo false)"
echo ""
