pcall(require, "luarocks.loader")

-- Set the theme
require(require("configuration.user-variables").ThemePath)

-- Run the startup autorun script
require("configuration.auto-start")

-- Set garbage collector
local gears = require("gears")
--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		collectgarbage("collect")
	end,
})