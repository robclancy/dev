#!/bin/bash
CCD2=$(sensors | grep 'Tccd2' | awk '{print $2}' | tr -d '+°C')
echo "temp|string|$CCD2"
echo ""