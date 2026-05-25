#!/bin/bash

WRONG=$(sensors | grep 'Tctl' | awk '{print $2}' | tr -d '+°C')
CCD1=$(sensors | grep 'Tccd1' | awk '{print $2}' | tr -d '+°C')
CCD2=$(sensors | grep 'Tccd2' | awk '{print $2}' | tr -d '+°C')
GPU=$(sensors | grep -A1 'amdgpu' | grep 'edge' | awk '{print $2}' | tr -d '+°C')

echo "wrong|string|$WRONG"
echo "ccd1|string|$CCD1"
echo "ccd2|string|$CCD2"
echo "gpu|string|$GPU"
echo ""

