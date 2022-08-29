#!/usr/bin/env bash

function run {
  if ! pgrep -f "$1" ;
  then
    $@ > /dev/null 2>&1 &
  fi
}

# bluetooth
run blueman-applet

# wifi 
run nm-applet

# power manager
run xfce4-power-manager

# to run i3lock with events
run xss-lock --transfer-sleep-lock -- i3lock-fancy --nofork

# run xrandr for display layout and resolution
#run autorandr --change
#run xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal

# compositor
run picom -b --config ~/.config/picom/picom.conf 

