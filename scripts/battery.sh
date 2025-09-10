#!/bin/bash

battery_normal_color="#a6e3a1"
battery_charging_color="#f9e2af"
battery_low_color="#f38ba8"

NOTCH_DAEMON_UTIL_PATH="/home/narval/.config/eww/notch_daemon/client_test.py"

PREV_BAT_STAT_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/notch_daemon/bat_state"
if [[ ! -f $PREV_BAT_STAT_FILE ]]; then
  mkdir -p "$(dirname "$PREV_BAT_STAT_FILE")"
  echo "a" > "$PREV_BAT_STAT_FILE"
fi

# n: no data ; h: High Bat Level ; m: Medium Bat Level ; l: Low Bat Levl
PREV_BAT_PERCENTAGE_STATE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/notch_daemon/bat_percentage_state"
if [[ ! -f  $PREV_BAT_PERCENTAGE_STATE_PATH ]]; then
  mkdir -p "$(dirname "$PREV_BAT_PERCENTAGE_STATE_PATH")"
  echo "n" > "$PREV_BAT_PERCENTAGE_STATE_PATH"
fi


PREV_BAT_STATE=$(<"$PREV_BAT_STAT_FILE")
PREV_BAT_PERCENTAGE_STATE=$(<"$PREV_BAT_PERCENTAGE_STATE_PATH")

bat_icon(){ 
  percentage=$(cat /sys/class/power_supply/BAT0/capacity)
  status=$(cat /sys/class/power_supply/BAT0/status)

  if [[ $status == "Charging" ]]; then   
    if  [[ $PREV_BAT_STATE != "c" ]]; then
        $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Charging", "icon_path": "/home/narval/.config/eww/icons/charging_battery.svg", "icon_color": "#a6e3a1", "urgency": 3}'
        echo c > "$PREV_BAT_STAT_FILE"
    fi
    echo "󱐋"

  else
    if  [[ $PREV_BAT_STATE != "d" ]]; then
        $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Discharging", "icon_path": "/home/narval/.config/eww/icons/discharging_battery_icon.svg", "icon_color": "#89b4fa", "urgency": 3}'
        echo d > "$PREV_BAT_STAT_FILE"
    fi

    if (( $percentage <= 10 )); then
      if [[ $PREV_BAT_PERCENTAGE_STATE != "l" ]]; then
        $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Low Battery", "icon_path": "/home/narval/.config/eww/icons/1-_5_battery.svg", "icon_color": "#f38ba8", "urgency": 1}'
        echo l > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      fi
      echo "󰁺"  

    elif (( $percentage <= 20 )); then
      echo m > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      echo "󰁻"
  
    elif (( $percentage <= 30 )); then
      echo m > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      echo "󰁼"
  
    elif (( $percentage <= 40 )); then
      echo m > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      echo "󰁽"
  
    elif (( $percentage <= 50 )); then
      echo m > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      echo "󰁾"
  
    elif (( $percentage <= 60 )); then
      echo m > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      echo "󰁿"
  
    elif (( $percentage <= 70 )); then
      echo h > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      echo "󰂀"
  
    elif (( $percentage <= 80 )); then
      echo h > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      echo "󰂁"
  
    elif (( $percentage <= 90 )); then
      echo h > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      echo "󰂂"
  
    else
      echo h > "$PREV_BAT_PERCENTAGE_STATE_PATH"
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

