#!/bin/bash
GPU=$(sensors | grep 'edge' | awk '{print $2}' | tr -d '+°C')
echo "temp|string|$GPU"
echo ""