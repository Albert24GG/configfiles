local awful = require("awful")
local layout = require(require("configuration.user-variables").ThemePath .. "layouts")

tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts{
        awful.layout.suit.tile.left,
        layout.termfair,
        layout.centerwork
    }
end)
