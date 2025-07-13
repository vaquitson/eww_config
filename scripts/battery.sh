#!/bin/bash

battery_normal_color="#a6e3a1"
battery_charging_color="#f9e2af"
battery_low_color="#f38ba8"


bat_icon(){ 
  percentage=$(cat /sys/class/power_supply/BAT0/capacity)
  status=$(cat /sys/class/power_supply/BAT0/status)

  if [[ $status == "Charging" ]]; then
    echo "󰂄"

  elif (( $percentage <= 10 )); then
    echo "󰁺"

  elif (( $percentage <= 20 )); then
    echo "󰁻"

  elif (( $percentage <= 30 )); then
    echo "󰁼"

  elif (( $percentage <= 40 )); then
    echo "󰁽"

  elif (( $percentage <= 50 )); then
    echo "󰁾"

  elif (( $percentage <= 60 )); then
    echo "󰁿"

  elif (( $percentage <= 70 )); then
    echo "󰂀"

  elif (( $percentage <= 80 )); then
    echo "󰂁"

  elif (( $percentage <= 90 )); then
    echo "󰂂"

  else
    echo "󱈑"

  fi
}

bat_percentage() {
	cat /sys/class/power_supply/BAT0/capacity
}


battery_color() {
  status=$(cat /sys/class/power_supply/BAT0/status)
  percentage=$(cat /sys/class/power_supply/BAT0/capacity)

  if [[ $status == "Charging" ]]; then
    echo $battery_charging_color
  elif [[ $percentage -le 10 ]]; then
    echo $battery_low_color
  else
    echo $battery_normal_color
  fi
}

if [[ "$1" == "-percentage" ]]; then
	bat_percentage

elif [[ "$1" == "-color" ]]; then
  battery_color

elif [[ "$1" == "-icon" ]]; then
  bat_icon

fi

