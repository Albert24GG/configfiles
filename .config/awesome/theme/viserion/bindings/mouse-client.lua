local awful = require("awful")
local naughty = require("naughty")
local Modkey = require("configuration.user-variables").Modkey

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        -- Mouse click to activate
        awful.button({},
                        1,
                        function (c)
                            c:emit_signal("request::activate", "mouse_click", {raise = true})
                        end),

        -- Mouse click with super to move
        awful.button({ Modkey},
                        1,            
                        function (c)
                            c.maximized = false
                            c:emit_signal("request::activate", "mouse_click", {raise = true})
                            awful.mouse.client.move(c)
                        end),

        -- Right mouse click to resize
        awful.button({ Modkey},
                        3,
                        function (c)
                            c:emit_signal("request::activate", "mouse_click", {raise = true})
                            awful.mouse.client.resize(c)
                        end),

        -- Mouse back button to kill client with super
        awful.button({ Modkey},
                        8,
                        function (c)
                            c:kill()
                        end),

        -- Mouse forward button to toggle floating for client
        awful.button({ Modkey},
                        9,
                        function(c)
                            c:emit_signal("request::activate", "mouse_click", {raise = true})
                            awful.client.floating.toggle()
                            if c.floating then
                                awful.placement.under_mouse(c)
                            end
                        end)
    })
end)
