#!/bin/bash

workspaces=$(hyprctl workspaces -j)
active_id=$(hyprctl activeworkspace -j | jq '.id')

echo -n "workspaces|string|"
echo "$workspaces" | jq -c '.[]' | while read -r workspace; do
 id=$(echo "$workspace" | jq '.id')
 name=$(echo "$workspace" | jq -r '.name')
 windows=$(echo "$workspace" | jq '.windows')

 output="$name"

 if [ $id -eq $active_id ]; then
	 output="-$output-"
 fi

 if [ $windows -gt 0 ]; then
	 output="$output"
 fi

 echo -n "$output "
done

echo ""
echo ""

