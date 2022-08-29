local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local menubar = require("menubar")

return function(args)
    local args      = args or {}
    local scr       = args.scr or screen.primary
    local spc       = args.spc or 1
    local mar       = args.mar or 0
    local icon_marg = args.icon_marg or 0.5
    
    return wibox.widget{
        {
            {
                nil,
                {
                    widget = wibox.container.constraint,
                    strategy = "max",
                    width = beautiful.tasklist_width-10,
                    {
                        widget = awful.widget.tasklist{
                            screen  = scr,
                            filter   = awful.widget.tasklist.filter.currenttags,
                            layout   =
                            {
                                spacing = spc,
                                layout  = wibox.layout.flex.horizontal
                            },
                            
                            style =
                            {
                                shape = function(cr, w, h)
                                    gears.shape.rounded_bar(cr, w, h)
                                end,
                                --shape = gears.shape.circle
                            },
                            
                            widget_template =
                            {
                                nil,
                                
                                {
                                    {
                                        {
                                            id     = 'clienticon',
                                            widget = awful.widget.clienticon,
                                            icon_surface = nil,
                                        },
                                        margins = icon_marg,
                                        widget  = wibox.container.margin
                                    },
                                    
                                    widget = wibox.container.place,
                                    valign = "center",
                                    halign = "center",
                                },
                                
                                {
                                    wibox.widget.base.make_widget(),
                                    forced_height = 4,
                                    id     = 'background_role',
                                    widget = wibox.container.background,
                                },
                                layout = wibox.layout.align.vertical,
                                
                                tt = nil,
                                
                                -- create callback to set the color of bg_focus
                                create_callback = function(self, c, _index, _clients)
                                    local client_icon = self:get_children_by_id('clienticon')[1]
                                    client_icon.client = c
                                    
                                    -- Set fallback icon in case none is found
                                    if not next(c.icon_sizes) then
                                        client_icon.icon_surface = gears.surface(require("icons").default_app_icon)
                                        c.icon = client_icon.icon_surface._native
                                    end

                                    if c.name ~= nil or c.instance ~= nil or c.class ~= nil then
                                        local icon = menubar.utils.lookup_icon(c.instance) or menubar.utils.lookup_icon(c.name) or menubar.utils.lookup_icon(c.class)
                                        local lower_icon = menubar.utils.lookup_icon(c.instance:lower()) or menubar.utils.lookup_icon(c.name:lower()) or menubar.utils.lookup_icon(c.class:lower())
                                        
                                        if icon ~= nil then
                                            client_icon.icon_surface = gears.surface(icon) 
                                            c.icon = client_icon.icon_surface._native
                                        elseif lower_icon ~= nil then 
                                            client_icon.icon_surface = gears.surface(lower_icon)
                                            c.icon = client_icon.icon_surface._native
                                        end
                                    end

                                    self:connect_signal('mouse::enter', function()
                                        self.bg = beautiful.tasklist_bg_focus
                                        if c then self.tt:set_text(c.name) end
                                    end)

                                    
                                    self:connect_signal('mouse::leave', function()
                                        if c == client.focus then
                                            self.bg = beautiful.tasklist_bg_focus
                                        elseif c.valid and c.urgent then
                                            self.bg = beautiful.tasklist_bg_urgent
                                        else
                                            self.bg = beautiful.tasklist_bg_normal
                                        end
                                    end)
                                    
                                    -- set up a tooltip to show full name of client
                                    self.tt = awful.tooltip({
                                        objects = {self},
                                        mode = 'outside',
                                        align = 'bottom',
                                        text = c.name,
                                    }) 
                                end,
                            },

                            buttons = {
                                -- left click, activate or minimize
                                awful.button({ }, 1, function (c)
                                                      if c == client.focus then
                                                          c.minimized = true
                                                      else
                                                          c:emit_signal(
                                                              "request::activate",
                                                              "tasklist",
                                                              {raise = true}
                                                          )
                                                      end
                                                  end),

                                -- middle click, kill
                                awful.button({ }, 2, function(c)
                                                      c:kill()
                                                  end),

                                -- right click, show menu
                                awful.button({ }, 3, function()
                                                      awful.menu.client_list({ theme = { width = 250 } })
                                                  end),

                                -- scroll between clients
                                awful.button({ }, 4, function ()
                                                      awful.client.focus.byidx(1)
                                                  end),
                                awful.button({ }, 5, function ()
                                                      awful.client.focus.byidx(-1)
                                                  end)

                            }
                        }
                    }
                },
                nil,
                layout = wibox.layout.align.horizontal,
                expand = "none"
            },

            shape = function(cr, w, h)
                gears.shape.rounded_rect(cr, w, h, beautiful.wibar_rad)
            end,
            bg = beautiful.tasklist_bg_widget,
            widget = wibox.container.background
        },

        margins = mar,
        widget = wibox.container.margin
    }
end
