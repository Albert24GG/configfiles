
hl.config({
  general = {
    border_size = 2,
    gaps_in = 5,
    gaps_out = 5,

    col = {
      active_border = "rgba(88c0d0ff)",
      inactive_border = "rgba(4c566aff)",
    },

    layout = "dwindle",

    resize_on_border = true,

    snap = {
        enabled = true,
        window_gap = 4,
        monitor_gap = 5,
        respect_gaps = true
    }
  },

  decoration = {
    rounding_power = 2.5,
    rounding = 10,

    blur = {
      enabled = false,
      xray = true,
      size = 10,
      passes = 3,
      brightness = 1,
      noise = 0.05,
      contrast = 0.89,
      vibrancy = 0.5,
      vibrancy_darkness = 0.5,
      popups = false,
      popups_ignorealpha = 0.6,
      input_methods = true,
      input_methods_ignorealpha = 0.8
    },

    shadow = {
      enabled = false,
      range = 20,
      offset = {0, 2},
      render_power = 10,
      color = "rgba(18192688)"
    },

    dim_inactive = true,
    dim_strength = 0.05
  },

  animations = {
    enabled = true
  },

  dwindle = {
      preserve_split = true,
      smart_split = false,
      smart_resizing = false
  },

  input = {
    repeat_delay = 250,
    repeat_rate = 35,

    touchpad = {
      natural_scroll = true,
      middle_button_emulation = true,
      clickfinger_behavior = true,
      scroll_factor = 0.7
    }
  },

  gestures = {
      workspace_swipe_distance = 700,
      workspace_swipe_cancel_ratio = 0.2,
      workspace_swipe_min_speed_to_force = 5,
      workspace_swipe_direction_lock = true,
      workspace_swipe_direction_lock_threshold = 10,
      workspace_swipe_create_new = true
  },


  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_enables_dpms = true,
    force_default_wallpaper = 0,
    vrr = 2,
    focus_on_activate = true
  },

  cursor = {
    zoom_disable_aa = true
  },

  xwayland = {
    force_zero_scaling = true
  },
})

-- Gestures

hl.gesture({
    fingers = 3,
    direction = "swipe",
    action = "move"
})

hl.gesture({
    fingers = 3,
    direction = "pinch",
    action = "fullscreen"
})
hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace"
})

-- Bezier Curves
hl.curve("expressiveFastSpatial", {
    type = "bezier",
    points = {{0.42, 1.67}, {0.21, 0.90}}
})
hl.curve("expressiveSlowSpatial", {
    type = "bezier",
    points = {{0.39, 1.29}, {0.35, 0.98}}
})
hl.curve("expressiveDefaultSpatial", {
    type = "bezier",
    points = {{0.38, 1.21}, {0.22, 1.00}}
})
hl.curve("emphasizedDecel", {
    type = "bezier",
    points = {{0.05, 0.7}, {0.1, 1}}
})
hl.curve("emphasizedAccel", {
    type = "bezier",
    points = {{0.3, 0}, {0.8, 0.15}}
})
hl.curve("standardDecel", {
    type = "bezier",
    points = {{0, 0}, {0, 1}}
})
hl.curve("menu_decel", {
    type = "bezier",
    points = {{0.1, 1}, {0, 1}}
})
hl.curve("menu_accel", {
    type = "bezier",
    points = {{0.52, 0.03}, {0.72, 0.08}}
})
hl.curve("stall", {
    type = "bezier",
    points = {{1, -0.1}, {0.7, 0.85}}
})

-- Animations
-- windows
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel",
    style = "popin 80%"
})
hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel"
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 2,
    bezier = "emphasizedDecel",
    style = "popin 90%"
})
hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 2,
    bezier = "emphasizedDecel"
})
hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel",
    style = "slide"
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "emphasizedDecel"
})

-- layers
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 2.7,
    bezier = "emphasizedDecel",
    style = "popin 93%"
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 2.4,
    bezier = "menu_accel",
    style = "popin 94%"
})

-- fade
hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 0.5,
    bezier = "menu_decel"
})
hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 2.7,
    bezier = "stall"
})

-- workspaces
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 7,
    bezier = "menu_decel",
    style = "slide"
})

-- zoom
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 3,
    bezier = "standardDecel"
})

