#!/bin/bash

# This scrip receives 3 arguments:
# 1. A colon separated list of monitor specs with the following format:
#   <monitor_name>,<monitor_res>,<monitor_offset>,<monitor_scale>
# 2. A colon separated list of the high refresh rate of the monitors
# 3. A colon separated list of the low refresh rate of the monitors

printf "%s\n%s\n%s\n%s\n%s\n" "$1" "$2" "$3" "$HYPRLAND_INSTANCE_SIGNATURE" "$(id -u)" >/tmp/.monitors_info
