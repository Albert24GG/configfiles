hl.on("hyprland.start", function()

  -- Dank Material Shell
  hl.exec_cmd("uwsm-app -s b -- dms run")

  -- Screen Sharing
  hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- Clipboard manager
  hl.exec_cmd("uwsm-app -s b -- clipse -listen")

  -- Walker launcher service
  hl.exec_cmd("uwsm-app -s b -- walker --gapplication-service")
end)
