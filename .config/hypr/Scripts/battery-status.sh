#!/bin/sh

status="$(cat /sys/class/power_supply/BAT*/status)"
level="$(cat /sys/class/power_supply/BAT*/capacity)"
ac_online="$(cat /sys/class/power_supply/AC*/online)"

if [[ ("$ac_online" -eq 1) ]]; then
  if [[ "$status" == "Charging" ]]; then
    printf "%s%%  " "$level"
  else
    printf "%s%%  " "$level"
  fi
else
  if [[ "$level" -eq "0" ]]; then
    printf "%s%%  " "$level"
  elif [[ ("$level" -ge "0") && ("$level" -le "25") ]]; then
    printf "%s%%  " "$level"
  elif [[ ("$level" -ge "25") && ("$level" -le "50") ]]; then
    printf "%s%%  " "$level"
  elif [[ ("$level" -ge "50") && ("$level" -le "75") ]]; then
    printf "%s%%  " "$level"
  elif [[ ("$level" -ge "75") && ("$level" -le "100") ]]; then
    printf "%s%%  " "$level"
  fi
fi

