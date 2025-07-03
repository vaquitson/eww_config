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


if [[ "$1" == "pop_bright_volumen" ]]; then
  open_pop_bright_volumen
fi

