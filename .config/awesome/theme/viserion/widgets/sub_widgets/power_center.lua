--- Power Options screen
-- Adopted from: https://github.com/PapyElGringo/material-awesome/blob/master/module/exit-screen.lua
local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local icons = require('icons')
local beautiful = require('beautiful')

-- Power buttons builder
local function build_button(args)
    local args = args or {}
    local icon = args.icon or nil
    local icon_size = args.icon_size or 100
    local release_cb = args.release_cb or function () end

    local btn = wibox.widget{
        {
            {
                {
                    {
                        image = icon,
                        widget = wibox.widget.imagebox
                    },

                    margins = 16,
                    widget = wibox.container.margin
                },

                id = "mouse_effect",
                widget = wibox.container.background,
                shape = gears.shape.circle,
                forced_width = icon_size,
                forced_height = icon_size,
            },

            left = 24,
            right = 24,
            widget = wibox.container.margin,
        },

        widget =  wibox.container.place,
        valign = "center",
        buttons = {
            awful.button({ }, 1, release_cb),
        },
    }

    local mouse_effect = btn:get_children_by_id("mouse_effect")[1]
    local old_cursor, old_wibox
    mouse_effect:connect_signal("mouse::enter", function()
        mouse_effect.bg = beautiful.bg_focus
        local w = mouse.current_wibox
        if w then
            old_cursor, old_wibox = w.cursor, w
            w.cursor = 'hand2'
        end
    end)
    mouse_effect:connect_signal("mouse::leave", function()
            mouse_effect.bg = beautiful.full_transparent
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
    end)

    return btn
end

return function (args)
    local args = args or {}

    local icon_size = args.icon_size or 150
    local backdrop_bg = args.backdrop_bg or "#000000bb"
    local screen_geo = awful.screen.focused().geometry

    local power_center = wibox{
        visible = false,
        ontop = true,
        type = 'splash',
        x = screen_geo.x,
        y = screen_geo.y + (screen_geo.height/2) - 100,
        width = screen_geo.width,
        height = 200,
        bg = "00000000"
    }

    -- This is the invisible wibox.
    -- so the the_wibox will hide if you click anywhere outside the_wibox
    power_center.backdrop = wibox {
        ontop = true,
        visible = false,
        type = 'splash',
        x = screen_geo.x,
        y = screen_geo.y,
        width = screen_geo.width,
        height = screen_geo.height,
        bg = backdrop_bg,
    }

    power_center.power_center_grabber = nil

    function power_center:power_center_hide()
        awful.keygrabber.stop(self.power_center_grabber)
        self.visible = false
        self.backdrop.visible = false
    end

    -- hide both on mouse clicks
    power_center:buttons{
            awful.button( {}, 2, function() power_center:power_center_hide() end),
            awful.button( {}, 3, function() power_center:power_center_hide() end)
    }
    power_center.backdrop:buttons{
            awful.button( {}, 1, function() power_center:power_center_hide() end),
            awful.button( {}, 2, function() power_center:power_center_hide() end),
            awful.button( {}, 3, function() power_center:power_center_hide() end)
    }

    local function lock_command()
        power_center:power_center_hide()
        awful.spawn.with_shell("loginctl lock-session")
    end

    local function poweroff_command()
        awful.spawn.with_shell('systemctl poweroff')
        awful.keygrabber.stop(power_center.power_center_grabber)
    end

    local function reboot_command()
        awful.spawn.with_shell('systemctl reboot')
        awful.keygrabber.stop(power_center.power_center_grabber)
    end

    local function logout_command()
        _G.awesome.quit()
    end

    local function suspend_command()
      power_center:power_center_hide()
      awful.spawn.with_shell('systemctl suspend')
    end

    local poweroff = build_button({
        icon = icons.power,
        icon_size = icon_size,
        release_cb = poweroff_command
    })

    local reboot = build_button({
        icon = icons.restart,
        icon_size = icon_size * .68,
        release_cb = reboot_command
    })

    local lock = build_button({
        icon = icons.lock,
        icon_size = icon_size * .68,
        release_cb = lock_command
    })

    local logout = build_button({
        icon = icons.logout,
        icon_size = icon_size * .68,
        release_cb = logout_command
    })

    local suspend = build_button({
        icon = icons.sleep,
        icon_size = icon_size * .68,
        release_cb = suspend_command
    })

    function power_center:power_center_show()
        -- grap keyboard
        self.power_center_grabber = awful.keygrabber.run(function(_, key, event)
            if event == 'release' then
                return
            end

            if key == 'l' then
                lock_command()
            elseif key == 'p' then
                poweroff_command()
            elseif key == 'r' then
                reboot_command()
            elseif key == 'e' then
                logout_command()
            elseif key == 's' then
                suspend_command()
            elseif key == 'Escape' or key == 'q' or key == 'x' then
                self:power_center_hide()
            end
        end)

        -- show them
        self.backdrop.visible = true
        power_center.visible = true
    end

    function power_center:power_center_toggle()
        if self.visible then self:power_center_hide() else self:power_center_show() end
    end

    power_center:setup {
        nil,
        {
            nil,
            {
                suspend,
                reboot,
                poweroff,
                lock,
                logout,
                layout = wibox.layout.fixed.horizontal
            },
            nil,
            expand = 'none',
            layout = wibox.layout.align.horizontal
        },
        nil,
        expand = 'none',
        layout = wibox.layout.align.vertical
    }

    return power_center
end
