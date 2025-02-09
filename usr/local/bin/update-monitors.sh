#!/bin/bash

# Add /usr/bin to the PATH
export PATH=/usr/bin:$PATH

info_file=/tmp/.monitors_info.json
hyprland_inst_sig=$(jq -r '.hyprland_inst_sig' $info_file)
user_id=$(jq -r '.user_id' $info_file)
power_supply_online=$(cat /sys/class/power_supply/A*/online)

# Set the HYPRLAND_INSTANCE_SIGNATURE environment variable
export HYPRLAND_INSTANCE_SIGNATURE="$hyprland_inst_sig"

if [ "$power_supply_online" -eq 0 ]; then
  rr_mode="low_rr"
else
  rr_mode="high_rr"
fi

function exec_cmd_as_usr() {
  local user_id="$1"
  shift
  sudo --preserve-env -u "$(id -nu "$user_id")" "$@"
}

active_monitors=$(exec_cmd_as_usr "$user_id" hyprctl monitors -j | jq -r '.[].name')
echo "Active monitors: $active_monitors"

jq -c '.monitors[]' $info_file | while read -r monitor; do
  name=$(echo "$monitor" | jq -r '.name')

  # Check if monitor is active, otherwise skip
  if ! echo "$active_monitors" | grep -q "^$name$"; then
    continue
  fi

  resolution=$(echo "$monitor" | jq -r '.resolution')
  refresh_rate=$(echo "$monitor" | jq -r ".$rr_mode")
  x=$(echo "$monitor" | jq -r '.x')
  y=$(echo "$monitor" | jq -r '.y')
  scale=$(echo "$monitor" | jq -r '.scale')

  hyprctl_arg="${name},${resolution}@${refresh_rate},${x}x${y},${scale}"
  echo "Setting monitor: $hyprctl_arg"

  exec_cmd_as_usr "$user_id" hyprctl keyword monitor "$hyprctl_arg"
done
