local main_mod = "SUPER"

-- Exec Binds

local launcher = "walker"
local terminal = "uwsm-app wezterm"
local logout_menu = "wlogout"

local region_screenshot = "hyprshot -m region -o ~/Screenshots"
local full_screenshot = "hyprshot -m output -o ~/Screenshots"

local open_clipboard = "wezterm start --class clipse -e clipse"

hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(launcher))
hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + BACKSPACE", hl.dsp.exec_cmd(logout_menu))

hl.bind(main_mod .. " + SHIFT + S", hl.dsp.exec_cmd(region_screenshot))
hl.bind("Print", hl.dsp.exec_cmd(full_screenshot))

hl.bind(main_mod .. " + SHIFT + V", hl.dsp.exec_cmd(open_clipboard))

-- Volume Control Binds

local volume_step = 2

local toggle_volume = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
local toggle_mic = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"
local volume_up = "pactl set-sink-volume @DEFAULT_SINK@ +" .. volume_step .. "%"
local volume_down = "pactl set-sink-volume @DEFAULT_SINK@ -" .. volume_step .. "%"

hl.bind("XF86AudioMute", hl.dsp.exec_cmd(toggle_volume))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(toggle_mic))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume_up))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume_down))


-- Brightness Control Binds

local brightness_step = 2

local brightness_up = "brightnessctl set " .. brightness_step .. "%+"
local brightness_down = "brightnessctl set " .. brightness_step .. "%-"

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(brightness_up))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightness_down))

-- Layout Binds

hl.bind(main_mod .. " + S", hl.dsp.layout("togglesplit"))

-- Window Binds

hl.bind(main_mod .. " + SHIFT + SPACE", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(main_mod .. " + SHIFT + M", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(main_mod .. " + ALT + M", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))

for i = 1, 4 do
    local vim_key = { "h", "l", "k", "j" }
    local focus_dir = { "l", "r", "u", "d" }
    hl.bind(main_mod .. " + " .. vim_key[i], hl.dsp.focus({ direction = focus_dir[i] }))
end

for i = 1, 4 do
    local vim_key = { "h", "l", "k", "j" }
    local focus_dir = { "l", "r", "u", "d" }
    hl.bind(main_mod .. " + SHIFT + " .. vim_key[i], hl.dsp.window.move({ direction = focus_dir[i] }))
end

for i = 1, 4 do
    local arrow_key = { "Left", "Right", "Up", "Down" }
    local resize_step = 15
    local resize_offset = { { -resize_step, 0 }, { resize_step, 0 }, { 0, -resize_step }, { 0, resize_step } }
    hl.bind(main_mod .. " + " .. arrow_key[i], hl.dsp.window.resize({ x = resize_offset[i][1], y = resize_offset[i][2] }))
end

for i = 1, 10 do
    hl.bind(main_mod .. " + SHIFT + " .. (i % 10), hl.dsp.window.move({ workspace = i }))
end

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- Workspace Binds

for i = 1, 10 do
    hl.bind(main_mod .. " + " .. (i % 10), hl.dsp.focus({ workspace = i }))
end


hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "+1" }))
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "-1" }))


-- Zoom Binds
local function zoom_fn(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end


for i = 1, 4 do
    zoom_key = { "Minus", "+ CTRL + mouse_down", "Equal", "+ CTRL + mouse_up" }
    zoom_value = { -0.3, -0.3, 0.3, 0.3 }
    hl.bind(main_mod .. " + " .. zoom_key[i], function() zoom_fn(zoom_value[i]) end, { repeating = true })
end
