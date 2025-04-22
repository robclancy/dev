#!/bin/bash

CPU_TEMP=$(sensors | grep 'Tctl' | awk '{print $2}' | tr -d '+°C')

echo "temp|string|$CPU_TEMP"
echo ""

