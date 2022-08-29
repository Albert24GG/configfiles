local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("beautiful")

-- lambdas to get the coordinates and dimensions of
-- client w.r.t primary screen, to be used
-- with dropdown_terminal and neomutt rules
local workarea = screen.primary.workarea
local function get_pW(p)
        return workarea.width * p
end
local function get_pX(p)
        return workarea.width * ((1-p)/2) + workarea.x
end
local function get_pH(p)
        return workarea.height * p
end
local function get_pY(p)
        return workarea.height * ((1-p)/2) + workarea.y
end

ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rules({
        -- All clients will match this rule.
        {
            rule = { },
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.centered
            }
        },

        -- Floating clients.
        {
            rule_any = {
                instance = {
                    "Places" -- firefox's library
                },

                class = {
                    "feh",
                    "Nm-connection-editor",
                    "Arandr",
                    "Blueman-manager",
                    "Gpick",
                    "nm-connection-editor",
                    "Pavucontrol",
                    "Seahorse",
                    "Nemo",
                    "Gnome-calculator",
                    "Gnome-screenshot",
                    "Lxappearance",
                    "install4j-burp-StartBurp",
                },

                name = {
                    "Event Tester",  -- xev.
                    "Xerox AltaLink C8030/C8035/C8045/C8055/C8070 PS"
                },

                role = {
                    "toolbox",       -- e.g. Firefox (detached) Developer Tools.
                }
            },

            properties = {
                floating = true
            }
        },

        -- dropdown terminal
        {
            rule_any = {
                  role = {
                      "dropdown_terminal"
                  }
            },

            properties = {
                floating = true,
                width = get_pW(0.5),
                height = get_pH(0.5),
                x = get_pX(0.5),
                y = get_pY(0.5)
            }
        },

        -- Neomutt
        {
            rule_any = {
                role = {
                    "neomutt"
                }
            },

            properties = {
                floating = true,
                width = get_pW(0.9),
                height = get_pH(0.87),
                x = get_pX(0.9),
                y = get_pY(0.87)
          }
        }

    })
end)
