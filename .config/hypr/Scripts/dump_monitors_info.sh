#!/bin/bash

# This script receives 1 argument:
# 1. The path to the json file with the monitors info
USER_ID=$(id -u)
MONITORS_INFO_FILE=$1

jq --arg user_id "$USER_ID" --arg instance_sig "$HYPRLAND_INSTANCE_SIGNATURE" '. + {user_id: $user_id, hyprland_inst_sig: $instance_sig}' "$MONITORS_INFO_FILE" >/tmp/.monitors_info.json
