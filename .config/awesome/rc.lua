pcall(require, "luarocks.loader")


-- Error handling
local naughty 	= require("naughty")
local beautiful = require("beautiful")
naughty.connect_signal(
	'request::display_error',
	function(message, startup)
		naughty.notification {
			urgency = 'critical',
			title   = 'Oops, an error happened'..(startup and ' during startup!' or '!'),
			message = message,
			app_name = 'System Notification',
			-- icon = beautiful.awesome_icon
		}
	end
)


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