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

# run the gnome polkit
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

# run autorandr for display layout and resolution
#run autorandr --change

# compositor
run picom -b --config ~/.config/picom/picom.conf 

