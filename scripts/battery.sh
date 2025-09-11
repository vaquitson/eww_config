#!/bin/bash

NOTCH_DAEMON_UTIL_PATH="/home/narval/.config/eww/notch_daemon/client_test.py"
BAT_PERCENTAGE=$(cat /sys/class/power_supply/BAT0/capacity) 
EWW_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/eww"

get_eww_config_dir(){
  echo "${XDG_CONFIG_HOME:-$HOME/.config}/eww"
}

_check_state_file(){
  PREV_STATE_FILE_PATH="$1"
  if [[ ! -f $PREV_STATE_FILE_PATH ]]; then
    mkdir -p "$PREV_STATE_FILE_PATH"  
    echo "n" > "$PREV_STATE_FILE_PATH"
  fi
}

battery_normal_color="#f5e0dc"
battery_charging_color="#a6e3a1"
battery_low_color="#f38ba8"

LOW_BATTERY_PERCENTAGE=10

# n: no data ; c: Charging ; d: Discharging 
BAT_PREV_STATE_FILE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/notch_daemon/bat_state"
_check_state_file ${BAT_PREV_STATE_FILE_PATH}
PREV_BAT_STATE=$(cat "$BAT_PREV_STATE_FILE_PATH")

# n: no data ; h: High Bat Level ; m: Medium Bat Level ; l: Low Bat Levl
PREV_BAT_PERCENTAGE_STATE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/notch_daemon/bat_percentage_state"
_check_state_file ${PREV_BAT_PERCENTAGE_STATE_PATH}

PREV_BAT_PERCENTAGE_STATE=$(cat "$PREV_BAT_PERCENTAGE_STATE_PATH")

bat_icon(){ 
  percentage=$(cat /sys/class/power_supply/BAT0/capacity)
  status=$(cat /sys/class/power_supply/BAT0/status)

  if [[ $status == "Charging" ]]; then   
    if  [[ $PREV_BAT_STATE != "c" ]]; then
        $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Charging", "icon_path": "󱐋", "icon_color": "#a6e3a1", "urgency": 3}'
        echo c > "$BAT_PREV_STATE_FILE_PATH"
    fi
    echo "󱐋"

  else
    if  [[ $PREV_BAT_STATE != "d" ]]; then
        $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Discharging", "icon_path": "", "icon_color": "#89b4fa", "urgency": 3}'
        echo d > "$BAT_PREV_STATE_FILE_PATH"
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


send_notification(){
  PREV_STATE_FILE_PATH="$1"
  PREV_STATE="$2"
  CUR_STATE="$3"
  JSON_STR="$4"

  if [[ $PREV_STATE != $CUR_STATE ]]; then 
    $NOTCH_DAEMON_UTIL_PATH -n "${JSON_STR}"
    echo "${CUR_STATE}" > "$PREV_STATE_FILE_PATH"
  fi
}


bat_image_path(){
  status=$(cat /sys/class/power_supply/BAT0/status)
  if [[ $status == "Charging" ]]; then 
    if [[ $PREV_BAT_STATE != 'c' ]]; then
        $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Charging", "icon_path": "/home/narval/.config/eww/icons/charging_battery.svg", "icon_color": "#a6e3a1", "urgency": 3}'
        echo c > "$BAT_PREV_STATE_FILE_PATH"
    fi
    echo "/home/narval/.config/eww/icons/charging_battery.svg"

  else
    if [[ $PREV_BAT_STATE != 'd' ]]; then
      $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Discharging", "icon_path": "/home/narval/.config/eww/icons/discharging_battery_icon.svg", "icon_color": "#89b4fa", "urgency": 3}'
      echo d > "$BAT_PREV_STATE_FILE_PATH"
    fi

    if (( $BAT_PERCENTAGE <= 10 )); then
      if [[ $PREV_BAT_PERCENTAGE_STATE != 'l' ]]; then
        $NOTCH_DAEMON_UTIL_PATH -n '{"title": "Low Battery", "icon_path": "/home/narval/.config/eww/icons/1-_5_battery.svg", "icon_color": "#f38ba8", "urgency": 1}'
        echo l > "$PREV_BAT_PERCENTAGE_STATE_PATH"
      fi
    else
      echo n > "$PREV_BAT_PERCENTAGE_STATE_PATH"
    fi
    
    # 20..100..20 means a range from 20 to 100 with steps of 20
    for i in {20..100..20}; do 
      if (( BAT_PERCENTAGE < i )); then
        echo "${EWW_CONFIG_DIR}/icons/group_1.svg"
        # echo "${EWW_CONFIG_DIR}/icons/battery_${i}.svg"
        break
      fi
    done
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

elif [[ "$1" == "-I" || "$1" == "--icon" ]]; then
  bat_image_path


fi

