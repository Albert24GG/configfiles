local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local function factory(args)
    local args = args or {}

    local shrink_title = args.shrink_title or "Nothing is playing."

    local scroll_speed = args.scroll_speed or 8
    local scroll_fps = args.scroll_fps or 5

    local icon_font = args.icon_font or beautiful.icon_fontname .. "23"
    local icon_play = args.icon_play or ""
    local icon_pause = args.icon_pause or ""
    local icon_stop = args.icon_stop or ""

    local player_name = args.player_name
    local playerctl = nil
    local player_manager = nil
    local timeout = args.timeout or 2

    local player =  wibox.widget{
        widget = wibox.container.background,
        bg = beautiful.player_bg_widget,
        -- Hide by default
        visible = false,

        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.wibar_rad)
        end,

        buttons = {
            awful.button({ }, 1, function()
                playerctl:play_pause()
            end), 
            awful.button({ }, 5, function()
                playerctl:next()
            end),
            awful.button({ }, 4, function()
                playerctl:previous()
            end)
        },

        {
            id = "ratio",
            layout = wibox.layout.ratio.horizontal,
            inner_fill_strategy = "default",
            spacing = 2,

            {
                widget = wibox.container.background,
                bg = beautiful.player_bg_icon,
                fg = beautiful.player_fg_icon,
                shape = gears.shape.circle,

                {
                    widget = wibox.container.place,
                    valign = "center",
                    halign = "center",
                    fill_vertical = true,
                    fill_horizontal = true,
                    content_fill_vertical = true,

                    {
                        id = "play_button",
                        widget = wibox.widget.textbox,
                        markup = string.format(
                                    "<span font='%s' foreground='%s' background='%s'>%s</span>",
                                    icon_font, beautiful.player_fg_icon, beautiful.player_bg_icon, icon_stop),
                    }
                }
            },

            {
                id = "scroll",
                layout = wibox.container.scroll.horizontal,
                speed = scroll_speed,
                fps = scroll_fps,
                step_function = wibox.container.scroll.step_functions
                                .linear_back_and_forth,

                {
                    widget = wibox.container.background,
                    bg = beautiful.player_bg_title,
                    fg = beautiful.player_fg_title,

                    {
                        id = "title_bar",
                        widget = wibox.widget.textbox,
                        text = shrink_title
                    }
                },
            },
        }
    }
    player:get_children_by_id("ratio")[1]:ajust_ratio(2, 0.15, 0.85, 0)

    function player:play()
        playerctl:play()
    end

    function player:pause()
        playerctl:pause()
    end

    function player:toggle()
        playerctl:play_pause()
    end

    function player:next()
        playerctl:next()
    end

    function player:prev()
        playerctl:previous()
    end

    function player:init_player(name)
        playerctl = require("lgi").Playerctl.Player({name})

        if playerctl == nil or playerctl.can_control == false then
            player:set_visible(false)
            return
        end

        playerctl.on_playback_status = function(p, sts)
            -- Show widget when something is playing
            player:set_visible(true)
            player:update_player_widget()
        end

        playerctl.on_exit = function (p)
            -- Hide widget when exiting player
            player:update_player_widget()
            player:set_visible(false)
        end

        playerctl.on_metadata = function(p, m)
            player:update_player_widget()
        end
        playerctl = require("lgi").Playerctl.Player({name})
        player:update_player_widget()
    end

    function player:setup_player_manager()
        player_manager = require("lgi").Playerctl.PlayerManager()

        
        player_manager.on_name_appeared = function(manager, name)
            if name.name == player_name then
                player:init_player(player_name)
            end
        end
        
        player_manager.on_player_vanished = function(manager, name)
            if name.name == player_name then
                playerctl = nil
            end
        end

        -- This is in case we restart awesome and
        -- there is already someting to manage
        player:init_player(player_name)
    end

    function player:update_player_widget()
        local sts = playerctl.playback_status
        local title = ""
        local artist = playerctl:get_artist()
        local music_title = playerctl:get_title()
        
        if (artist == nil or artist == "") then
            artist = ""
        end

        if (music_title == nil or music_title == "") then
            music_title = ""
        end

        
        if(music_title ~= "" and artist ~= "") then
            title = artist .. " • " .. music_title
        elseif (music_title ~= "") then
            title = music_title
        elseif (sts == "PLAYING") then
            title = "Unknown song"
        end
        
        local play_title_bar = player:get_children_by_id("title_bar")[1]
        if title == "" then
            play_title_bar:set_text(shrink_title)
        else
            play_title_bar:set_text(title)
        end

        local printed_icon = icon_play

        if sts == "STOPPED" then
            printed_icon = icon_stop
            player:set_visible(false)
        elseif sts == "PLAYING" then
            player:set_visible(true)
            printed_icon = icon_pause
        end

        local play_button = player:get_children_by_id("play_button")[1]
        play_button:set_markup(string.format(
                    "<span font='%s' foreground='%s' background='%s'>%s</span>",
                    icon_font, beautiful.player_fg_icon, beautiful.player_bg_icon, printed_icon))


        local scroll = player:get_children_by_id("scroll")[1]
    end

    -- Keep updating the widget
    local player_timer = gears.timer.start_new(timeout, function() 
        player:setup_player_manager()
        return true
    end)
    -- Cause timer to start immediately
    player_timer:emit_signal("timeout")

    return player
end

return factory
