local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local Modkey = require("configuration.user-variables").Modkey


return function(args)
    local args = args or {}
    local scr = args.scr or screen.primary
    local spc = args.spc or 4
    local mar = args.mar or 0

    return wibox.widget{
        {
            {
                widget = awful.widget.taglist{
                    screen  = scr,
                    filter  = awful.widget.taglist.filter.all,
                    layout   =
                    {
                        spacing = spc,
                        layout  = wibox.layout.flex.horizontal
                    },

                    style =
                    {
                        shape = gears.shape.circle
                    },

                    widget_template =
                    {
                        {
                            {
                                id     = 'text_role',
                                widget = wibox.widget.textbox,
                            },

                            valign = "center",
                            halign = "center",
                            fill_vertical  = true,
                            fill_horizontal  = true,
                            widget = wibox.container.place
                        },

                        id     = 'background_role',
                        widget = wibox.container.background,

                        -- create callback to setup mouse hover
                        create_callback = function(self, t, _index, _objects)
                            self:connect_signal('mouse::enter', function()
                                self.bg = beautiful.taglist_bg_focus
                            end)

                            self:connect_signal('mouse::leave', function()
                                if t.selected then
                                    self.bg = beautiful.taglist_bg_focus
                                elseif t.urgent then
                                    self.bg = beautiful.taglist_bg_urgent
                                else
                                    self.bg = beautiful.taglist_bg_normal
                                end
                            end)

                        end,
                    },

                    buttons = {
                        -- left click
                        awful.button({ }, 1, function(t)
                            local sc = awful.screen.focused()
                            if sc.selected_tag == t then
                                awful.tag.history.restore()
                            else
                                t:view_only()
                            end
                        end),

                        -- super + left click
                        awful.button({ Modkey }, 1, function(t)
                            if client.focus then
                                client.focus:move_to_tag(t)
                            end
                        end),

                        -- right click
                        awful.button({ }, 3, awful.tag.viewtoggle),
                        awful.button({ Modkey }, 3, function(t)
                            if client.focus then
                                client.focus:toggle_tag(t)
                            end
                        end),

                        -- scroll between tags
                        awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                        awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)

                    }
                }
            },
            shape = function(cr, w, h)
                gears.shape.rounded_rect(cr, w, h, beautiful.wibar_rad)
            end,
            bg = beautiful.taglist_bg_widget,
            widget = wibox.container.background
        },

        -- margins = mar,
        left = -1,
        widget = wibox.container.margin
    }
end
