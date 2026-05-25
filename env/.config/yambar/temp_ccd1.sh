#!/bin/bash
CCD1=$(sensors | grep 'Tccd1' | awk '{print $2}' | tr -d '+°C')
echo "temp|string|$CCD1"
echo ""