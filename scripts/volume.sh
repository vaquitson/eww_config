#!/bin/sh

vol_vol() {
  pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n1 | tr -d '%'
}


if [[ "$1" == "vol" ]]; then
  vol_vol
fi

