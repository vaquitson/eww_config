#!/bin/bash

battery_normal_color="#a6e3a1"
battery_charging_color="#f9e2af"
battery_low_color="#f38ba8"

NOTCH_DAEMON_UTIL_PATH="/home/narval/.config/eww/notch_daemon/client_test.py"

PREV_BAT_STAT_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/notch_daemon/bat_state"
mkdir -p "$(dirname "$PREV_BAT_STAT_FILE")"
if [[ ! -f $PREV_BAT_STAT_FILE ]]; then
  echo "a" > "$PREV_BAT_STAT_FILE"
fi

PREV_BAT_STATE=$(<"$PREV_BAT_STAT_FILE")

bat_icon(){ 
  percentage=$(cat /sys/class/power_supply/BAT0/capacity)
  status=$(cat /sys/class/power_supply/BAT0/status)

  if [[ $status == "Charging" ]]; then   
    if  [[ $PREV_BAT_STATE != "c" ]]; then
        python3 $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Charging", "icon_path": "/home/narval/.config/eww/icons/charging_battery.svg", "icon_color": "#a6e3a1", "urgency": 3}'
        echo c > "$PREV_BAT_STAT_FILE"
    fi
    echo "󱐋"

  else
    if  [[ $PREV_BAT_STATE != "d" ]]; then
        python3 $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Discharging", "icon_path": "/home/narval/.config/eww/icons/discharging_battery_icon.svg", "icon_color": "#89b4fa", "urgency": 3}'
        echo d > "$PREV_BAT_STAT_FILE"
    fi

    if (( $percentage <= 10 )); then
      #python3 /home/narval/.config/eww/notch_daemon/client_test.py -n '{"title": "Low battery", "icon_path": "/home/narval/.config/eww/icons/low_battery.svg", "icon_color": "#f9e2af", "urgency": 1}'
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

