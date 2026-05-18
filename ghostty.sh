#!/usr/bin/env bash

mkdir ~/.config/ghostty/themes && wget -O- https://github.com/mbadolato/iTerm2-Color-Schemes/releases/download/release-20251201-150531-bfb3ee1/ghostty-themes.tgz | tar xz -C ~/.config/ghostty/themes/ --strip-components=1
