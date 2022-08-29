local awful = require("awful")
local Modkey = require("configuration.user-variables").Modkey

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        -- Move client to other screen
        awful.key({ Modkey,},
                    ".",
                    function (c)
                        c:move_to_screen()
                    end,
                    {description = "move client to other screen", group = "Screen", sort_order = 2}),

        -- Toggle fullscreen for client
        awful.key({ "Ctrl", "Shift"},
                    "f",
                    function (c)
                        c.fullscreen = not c.fullscreen
                        c:raise()
                    end,
                    {description = "toggle fullscreen", group = "Client", sort_order = 22}),

        -- Close client
        awful.key({ Modkey,},
                    "q",
                    function (c)
                        c:kill()
                    end,
                    {description = "close client", group = "Client", sort_order = 23}),

        -- Float client
        awful.key({ Modkey,},
                    "space",
                    function(c)
                        awful.client.floating.toggle()
                        if c.floating then
                            awful.placement.centered(c)
                        end
                    end,
                    {description = "float client", group = "Client", sort_order = 24}),

        -- Toggle maximizing client
        awful.key({ Modkey,},
                    "m",
                    function (c)
                        c.maximized = not c.maximized
                        c:raise()
                    end ,
                    {description = "toggle maximizing client", group = "Client", sort_order = 25}),

        -- Toggle sticky for client
        awful.key({ Modkey,},
                    "t",
                    function (c)
                        c.ontop = not c.ontop
                        c.sticky = c.ontop
                        c:raise()
                    end,
                    {description = "toggle sticky client", group = "Client", sort_order = 26})
    })
end)
