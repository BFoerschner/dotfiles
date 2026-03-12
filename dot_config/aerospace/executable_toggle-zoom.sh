#!/usr/bin/env bash
# ~/.config/aerospace/toggle-zoom.sh

STATE="/tmp/aerospace-zoom"

if [ -f "$STATE" ]; then
  rm "$STATE"
  aerospace balance-sizes
else
  touch "$STATE"
  aerospace balance-sizes
  aerospace resize width 2500
fi
