hl.on("hyprland.start", function()

  -- Dank Material Shell
  hl.exec_cmd("uwsm-app -s s -- dms run")

  -- Screen Sharing
  hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- Clipboard manager
  hl.exec_cmd("uwsm-app -s s -- clipse -listen")

  -- Walker launcher service
  hl.exec_cmd("uwsm-app -s s -- walker --gapplication-service")
end)
