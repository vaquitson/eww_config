#!/bin/bash

EWW_BIN="$HOME/r_repos/eww/target/release/eww"

CUR_TBW=$(${EWW_BIN} active-windows | grep tbw | cut -d':' -f2)

close(){
  if [[ -n "$CUR_TBW" ]]; then
    ${EWW_BIN} close tbw 
  fi
}

open_pop_bright_volumen(){
  close
  if [[ $CUR_TBW != " pop_bright_volumen" ]]; then
    ${EWW_BIN} open pop_bright_volumen --id tbw
  fi
}

open_pop_power_menu(){
  close
  if [[ $CUR_TBW != " pop_power_menu" ]]; then
    ${EWW_BIN} open pop_power_menu --id tbw
  fi
}

open_pop_wifi_menu(){
  close
  if [[ $CUR_TBW != " POP_wifi_menu" ]]; then
    ${EWW_BIN} open POP_wifi_menu --id tbw
  fi
}


if [[ "$1" == "pop_bright_volumen" ]]; then
  open_pop_bright_volumen

elif [[ "$1" == "pop_power_menu" ]]; then
  open_pop_power_menu

elif [[ "$1" == "pop_wifi_menu" ]]; then
  open_pop_wifi_menu
fi

