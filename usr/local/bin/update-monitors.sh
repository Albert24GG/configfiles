#!/bin/bash

hyprctl_bin=/usr/bin/hyprctl
info_file=/tmp/.monitors_info
hyprland_inst_sig=$(sed -n '4p' <$info_file)
user_id=$(sed -n '5p' <$info_file)

power_supply_online=$(cat /sys/class/power_supply/A*/online)

monitors_specs=$(sed -n '1p' <$info_file)
monitors_cnt=$(echo "$monitors_specs" | tr ':' ' ' | wc -w)

if [ "$power_supply_online" -eq 0 ]; then
  monitors_rr=$(sed -n '3p' <$info_file)
else
  monitors_rr=$(sed -n '2p' <$info_file)
fi

for i in $(seq 1 "$monitors_cnt"); do
  IFS=',' read -r -a monitor_specs <<<$(echo "$monitors_specs" | cut -d ':' -f "$i")

  # Append refresh rate to monitor specs
  monitor_specs[1]+="@$(echo "$monitors_rr" | cut -d ':' -f "$i")"

  /usr/bin/sudo -u "$(id -nu $user_id)" HYPRLAND_INSTANCE_SIGNATURE=$hyprland_inst_sig $hyprctl_bin keyword monitor $(echo "${monitor_specs[@]}" | tr ' ' ',')
done
