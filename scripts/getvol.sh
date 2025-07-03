#!/bin/sh

get() {
  pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n1
}

if [[ "$1" == "vol" ]]; then
  get
fi

