#!/usr/bin/env bash
# Fixes workspace↔monitor assignments at runtime without touching config files.
# Identifies physical monitors by description (stable across port swaps) and
# moves every workspace to the monitor it belongs on.
#
# Roles (by description substring, case-insensitive):
#   left   = Samsung   (1080p)   -> workspaces 6 7 8 9 10 67
#   middle = MSI / Microstep (ultrawide) -> workspaces 1 2 3 4
#   right  = ViewSonic (2560x1440) -> workspaces 5 11 12 13
#
# Usage: ~/.config/hypr/fix-monitors.sh

set -euo pipefail

LEFT_DESC="samsung"
MIDDLE_DESC="microstep"
RIGHT_DESC="viewsonic"

# Resolve a monitor's current port name by description substring.
get_port() {
	hyprctl monitors -j \
		| jq -r --arg desc "$1" \
			  '.[] | select((.description // "") | ascii_downcase | test($desc; "i")) | .name' \
		| head -n1
}

LEFT=$(get_port "$LEFT_DESC")
MIDDLE=$(get_port "$MIDDLE_DESC")
RIGHT=$(get_port "$RIGHT_DESC")

for role in LEFT MIDDLE RIGHT; do
	port="${!role}"
	if [ -z "$port" ]; then
		echo "fix-monitors: could not find monitor for role $role (desc ${role}_DESC)" >&2
		exit 1
	fi
	echo "$role = $port"
done

move_ws() {
	local ws="$1"
	local port="$2"
	hyprctl dispatch moveworkspacetomonitor "$ws" "$port"
}

# Middle (ultrawide): 1 2 3 4
for ws in 1 2 3 4; do
	move_ws "$ws" "$MIDDLE"
done

# Right (ViewSonic): 5 11 12 13
for ws in 5 11 12 13; do
	move_ws "$ws" "$RIGHT"
done

# Left (Samsung 1080p): 6 7 8 9 10 67
for ws in 6 7 8 9 10 67; do
	move_ws "$ws" "$LEFT"
done

echo "fix-monitors: done"
echo "--- monitors after ---"
hyprctl monitors | grep -iE 'Monitor|active workspace'