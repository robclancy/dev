#!/bin/bash
if [ -f /tmp/claude_done ]; then
    echo "state|int|$(( $(date +%s) / 10 % 2 + 1 ))"
else
    echo "state|int|0"
fi
echo ""
