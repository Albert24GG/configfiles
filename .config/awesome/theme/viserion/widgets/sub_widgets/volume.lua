-------------------------------------------------
-- Volume Widget for Awesome Window Manager
-- Shows the current volume level
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volume-widget

-- @author Pavel Makhov, Aurélien Lajoie
-- @copyright 2018 Pavel Makhov
-------------------------------------------------

local wibox = require("wibox")
local awful = require("awful")
local spawn = require("awful.spawn")
local naughty = require("naughty")
local gfs = require("gears.filesystem")

local PATH_TO_ICONS = string.format("/usr/share/icons/%s/symbolic/status/", require("configuration.user-variables").icon_theme)
local volume_icon_name="audio-volume-high-symbolic"
local GET_VOLUME_CMD = 'amixer sget Master'
local sound_control_gui = require("configuration.user-variables").default_apps.sound_control_gui

local volume = {device = '', display_notification = false, notification = nil, delta = 5}

function volume:toggle()
    volume:_cmd('amixer -D ' .. volume.device .. ' sset Master toggle')
end

function volume:raise()
    volume:_cmd('amixer -D ' .. volume.device .. ' sset Master ' .. tostring(volume.delta) .. '%+ on')
end
function volume:lower()
    volume:_cmd('amixer -D ' .. volume.device .. ' sset Master ' .. tostring(volume.delta) .. '%- on')
end

--{{{ Icon and notification update

--------------------------------------------------
--  Set the icon and return the message to display
--  base on sound level and mute
--------------------------------------------------
local function parse_output(stdout)
    local level = string.match(stdout, "(%d?%d?%d)%%")
    if stdout:find("%[off%]") or level == 0 then
        volume_icon_name="audio-volume-muted-symbolic"
        return level.."% (Mute)"
    end
    level = tonumber(string.format("% 3d", level))

    if (level == 0) then
        volume_icon_name="audio-volume-muted-symbolic"
        return level.."% (Mute)"
    elseif (level <= 33) then
        volume_icon_name="audio-volume-low-symbolic"
    elseif (level <= 66) then
        volume_icon_name="audio-volume-medium-symbolic"
    else
        volume_icon_name="audio-volume-high-symbolic"
    end
    return level.."%"
end

--------------------------------------------------------
--Update the icon and the notification if needed
--------------------------------------------------------
local function update_graphic(widget, stdout, _, _, _)
    local txt = parse_output(stdout)
    widget.image = PATH_TO_ICONS .. volume_icon_name .. ".svg"
    volume.tt:set_text(txt)
    if volume.display_notification then
        volume.notification.iconbox.image = PATH_TO_ICONS .. volume_icon_name .. ".svg"
        naughty.replace_text(volume.notification, "Volume", txt)
    end
end

local function notif(msg, keep)
    if volume.display_notification then
        naughty.destroy(volume.notification)
        volume.notification= naughty.notify{
            text =  msg,
            icon=PATH_TO_ICONS .. volume_icon_name .. ".svg",
            icon_size = 16,
            title = "Volume",
            position = volume.position,
            timeout = 1, hover_timeout = 0.5,
            width = 200,
            screen = mouse.screen
        }
    end
end

--}}}

local function worker(args)
--{{{ Args
    local args = args or {}

    local volume_audio_controller = args.volume_audio_controller or 'pulse'
    volume.display_notification = args.display_notification or false
    volume.position = args.notification_position or "top_right"
    volume.device = args.device or "default"

    if volume_audio_controller == 'pulse' then
        volume.device = 'pulse'
    end

    volume.delta = args.delta or 5
    GET_VOLUME_CMD = 'amixer -D ' .. volume.device.. ' sget Master'
--}}}
--{{{ Check for icon path
    if not gfs.dir_readable(PATH_TO_ICONS) then
        naughty.notify{
            title = "Volume Widget",
            text = "Folder with icons doesn't exist: " .. PATH_TO_ICONS,
            preset = naughty.config.presets.critical
        }
        return
    end
--}}}
--{{{ Widget creation
    volume.widget = wibox.widget {
        {
            id = "icon",
            image = PATH_TO_ICONS .. "audio-volume-muted-symbolic.svg",
            resize = false,
            widget = wibox.widget.imagebox,
        },
        layout = wibox.container.margin(_, _, _, 3),
        set_image = function(self, path)
            self.icon.image = path
        end
    }
--}}}
--{{{ Spawn functions
    function volume:_cmd(cmd)
        notif("")
        spawn.easy_async(cmd, function(stdout, stderr, exitreason, exitcode)
            update_graphic(volume.widget, stdout, stderr, exitreason, exitcode)
        end)
    end

    local function show()
        spawn.easy_async(GET_VOLUME_CMD,
        function(stdout, _, _, _)
        txt = parse_output(stdout)
        notif(txt, true)
        end
        )
    end
--}}}
--{{{ Mouse event
    --[[ allows control volume level by:
    - clicking on the widget to mute/unmute
    - scrolling when cursor is over the widget
    ]]
    volume.widget:connect_signal("button::press", function(_,_,_,button)
        if (button == 4)     then volume.raise()
        elseif (button == 5) then volume.lower()
        elseif (button == 1) then volume.toggle()
        elseif (button == 3) then awful.spawn.with_shell(sound_control_gui)
        end
    end)
    if volume.display_notification then
        volume.widget:connect_signal("mouse::enter", function() show() end)
        volume.widget:connect_signal("mouse::leave", function() naughty.destroy(volume.notification) end)
    end
--}}}

--{{{ Set initial icon
    spawn.easy_async(GET_VOLUME_CMD, function(stdout, stderr, exitreason, exitcode)
        parse_output(stdout)
        volume.widget.image = PATH_TO_ICONS .. volume_icon_name .. ".svg"
    end)
--}}}

    -- Tooltip to display whole title, if it was truncated
    volume.tt = awful.tooltip({
        objects = {volume.widget},
        mode = 'outside',
        align = 'bottom',
    })

    function volume:update_tt()
        spawn.easy_async(GET_VOLUME_CMD,
        function(stdout, _, _, _)
            txt = parse_output(stdout)
            volume.tt:set_text(txt)
        end
        )
    end

    volume.widget:connect_signal("mouse::enter", function() 
        volume:update_tt()
    end)
    return volume
end

-- return worker
return setmetatable(volume, { __call = function(_, ...) return worker(...) end })
