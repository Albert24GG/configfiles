local awful = require("awful")

-- Autostart programs
awful.spawn.with_shell("~/.config/awesome/configuration/autorun.sh")

-- Start redshift for automatic light color adjustment based on current time at your location
local coordinates = require("configuration.user-variables").weather.coordinates
awful.spawn.with_shell(string.format("redshift -l %s:%s", coordinates[1], coordinates[2]))