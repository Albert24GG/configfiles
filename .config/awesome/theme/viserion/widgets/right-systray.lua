local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local math = math
local naughty = require("naughty")
local ThemePath = require("configuration.user-variables").ThemePath
local sub_widgets = require(ThemePath .. "widgets.sub_widgets")

return function(args)
	local args = args or {}
	local spc = args.spc or 13
	local scr = args.scr or screen.primary
	local innmar = args.innmar or 4
	local mar = args.mar or 0

	-- Date widget

	local date_widget = wibox.widget({
		widget = wibox.container.margin,
		margins = mar,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = spc,

			{
				id = "icon_widget",
				widget = wibox.widget.textbox(""),
				font = beautiful.icon_fontname .. 13,
			},

			{
				id = "textbox_widget",
				widget = wibox.widget.textclock("%b %d, %Y"),
			},
		},
	})

	-- Create calendar widget
	date_widget:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			sub_widgets.calendar.toggle()
		end
	end)

	-- Time widget

	local clock_widget = wibox.widget({
		widget = wibox.container.margin,
		margins = mar,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = spc,

			{
				id = "icon_widget",
				widget = wibox.widget.textbox(""),
				font = beautiful.icon_fontname .. 16,
			},

			{
				id = "textbox_widget",
				widget = wibox.widget.textclock("%H:%M"),
			},
		},
	})

	-- Power button widget
	local power_widget = {
		widget = wibox.container.background,
		bg = beautiful.wibar_right_icon_bg,
		shape = gears.shape.circle,
		{
			widget = wibox.container.margin,
			margins = 3,
			{
				image = require("icons").power,
				widget = wibox.widget.imagebox,
				buttons = {
					awful.button({}, 1, function()
						beautiful.power_center:power_center_show()
					end),
				},
			},
		},
	}

	-- if this is not the primary screen, only return the date and time
	if scr ~= screen.primary then
		return wibox.widget({
			widget = wibox.container.margin,
			margins = mar,
			right = -1,
			{

				layout = wibox.layout.fixed.horizontal,
				spacing = spc,
				{

					shape = function(cr, w, h)
						gears.shape.rounded_rect(cr, w, h, beautiful.wibar_rad)
					end,
					bg = beautiful.wibar_systray_bg,
					widget = wibox.container.background(
{
						widget = wibox.container.margin,
						margins = innmar,
						{
							layout = wibox.layout.fixed.horizontal,
							spacing = spc,

							date_widget,

							clock_widget,
						},
					}),
				},

				{
					widget = wibox.container.constraint,
					height = beautiful.wibar_height,
					stratgy = "exact",
					power_widget,
				},
			},
		})
	end

	local volume_widget = sub_widgets.volume({
		volume_audio_controller = "alsa",
		device = "default",
	}).widget

	local systray_widget = wibox.widget({
		-- icons have space after them, remove it so that we have
		-- unified spacing
		widget = wibox.container.margin,
		left = -2,
		right = -2,
		wibox.widget.systray,
	})

	local keyboardlayout_widget = wibox.widget({
		widget = wibox.container.margin,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = 3,

			{
				id = "icon_widget",
				widget = wibox.widget.textbox(" "),
				font = beautiful.icon_fontname .. 13,
			},

			{
				id = "textbox_widget",
				widget = awful.widget.keyboardlayout,
			},
		},
	})

	local weather_widget = wibox.widget({
		-- icons have space after them, remove it so that we have
		-- unified spacing
		widget = wibox.container.margin,
		left = -4,
		sub_widgets.weather,
	})

	power_widget = wibox.widget({
		widget = wibox.container.constraint,
		height = beautiful.wibar_height,
		stratgy = "exact",
		power_widget,
	})

	-- export to beautiful to use in keybindings
	beautiful.volume = sub_widgets.volume
	beautiful.power_center = sub_widgets.power_center

	return wibox.widget({
		widget = wibox.container.margin,
		margins = mar,
		right = -1,
		{

			layout = wibox.layout.fixed.horizontal,
			spacing = spc,
			{

				shape = function(cr, w, h)
					gears.shape.rounded_rect(cr, w, h, beautiful.wibar_rad)
				end,
				bg = beautiful.wibar_systray_bg,
				widget = wibox.container.background(
{
					widget = wibox.container.margin,
					margins = innmar,
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = spc,

						weather_widget,

						sub_widgets.todo,

						--sub_widgets.brightness,

						volume_widget,

						keyboardlayout_widget,

						date_widget,

						clock_widget,

						systray_widget,
					},
				}),
			},
			power_widget,
		},
	})
end
