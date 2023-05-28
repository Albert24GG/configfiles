local theme_assets = require("beautiful.theme_assets")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local user_variables = require("configuration.user-variables")

local theme = {}

-- font
theme.fontname = user_variables.font.text
theme.icon_fontname = user_variables.font.icon
theme.fontsize = 10
theme.font = theme.fontname .. tostring(theme.fontsize)

-- black and white colors
theme.black_color = "#353535"
theme.white_color = "#ffffff"

-- theme colors
theme.primary_bg = theme.black_color .. "a0"
theme.secondary_bg = "#3d89c9"
theme.tertiary_bg = theme.secondary_bg .. "50"
theme.error_bg = "#91231c"
theme.full_transparent = "#ffffff00"

-- bg colors
theme.bg_normal = theme.primary_bg
theme.bg_focus = theme.secondary_bg
theme.bg_urgent = theme.error_bg
theme.bg_minimize = theme.tertiary_bg

-- fg colors
theme.fg_normal = theme.white_color
theme.fg_focus = theme.white_color
theme.fg_urgent = theme.white_color
theme.fg_minimize = theme.white_color

-- border and gap
theme.useless_gap = 5
theme.border_width = 2
theme.border_normal = theme.black_color
theme.border_focus = theme.secondary_bg
theme.border_marked = theme.error_bg

-- wallpapers"
theme.primary_wallpaper = user_variables.wallpaper.primary_screen
theme.secondary_wallpaper = user_variables.wallpaper.secondary_screen

-- wibar
theme.wibar_rad = 100
theme.wibar_width_ratio = 0.9
theme.wibar_height = 30
theme.wibar_top_margin = 3
theme.wibar_spacing = 20
theme.wibar_bg = theme.primary_bg
theme.wibar_right_icon_bg = theme.secondary_bg
theme.wibar_systray_bg = theme.full_transparent

-- systray
-- we cannot make the background of the systray transparent,
-- but we set it to the color of the background in that location
theme.bg_systray = "#7c615d"
theme.systray_icon_spacing = 4
--theme.systray_maxwidth = 700

-- taglist
theme.taglist_bg_widget = theme.tertiary_bg
theme.taglist_bg_focus = theme.secondary_bg
theme.taglist_bg_urgent = theme.error_bg
theme.taglist_bg_normal = theme.full_transparent
theme.taglist_bg_empty = theme.full_transparent
theme.taglist_bg_occupied = theme.full_transparent
theme.taglist_fg_focus = theme.fg_normal
theme.taglist_fg_urgent = theme.fg_normal
theme.taglist_fg_empty = theme.fg_normal
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_font = theme.icon_fontname .. "15"
theme.taglist_width = 200
local taglist_square_size = 7
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)

-- tasklist
theme.tasklist_bg_normal = theme.full_transparent
theme.tasklist_bg_focus = theme.secondary_bg
theme.tasklist_bg_urgent = theme.error_bg
theme.tasklist_bg_widget = theme.full_transparent
theme.tasklist_width = 300
--theme.cls_icons          = {}

-- tooltip
theme.tooltip_bg = theme.primary_bg
theme.tooltip_fg = theme.fg_normal
theme.tooltip_shape = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 10)
end

-- notification
theme.notification_font = theme.font
theme.notification_bg = theme.primary_bg
theme.notification_fg = theme.fg_normal
theme.notification_width = 300
theme.notification_max_height = 100
theme.notification_border_color = theme.border_focus
--theme.notification_border_color = theme.notification_bg
theme.notification_icon_size = 50
theme.notification_shape = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 10)
end

-- calendar
theme.calendar_style = {
	border_width = 0,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
}

-- player
theme.player_width = 200
theme.player_bg_title = theme.full_transparent
theme.player_fg_title = theme.fg_normal
theme.player_bg_widget = theme.tertiary_bg
theme.player_bg_icon = theme.secondary_bg
theme.player_fg_icon = theme.fg_normal

-- weather
theme.weather_bg = theme.full_transparent
theme.weather_border_color = theme.primary_bg
theme.weather_border_width = theme.border_width

-- power_options
theme.power_bg = theme.primary_bg
theme.power_fg = theme.fg_normal

-- icon theme
theme.icon_theme = user_variables.icon_theme

-- when connecting a screen
function theme.at_screen_connect(s)
	-- get the widgets for this screen
	s.widgets = require(user_variables.ThemePath .. "widgets")(s)

	-- Create the music player widget
	local player_widget = wibox.widget({
		widget = wibox.container.constraint,
		strategy = "exact",
		width = theme.player_width,
		s.widgets.player,
	})

	-- export player to beautiful to be used in keybindings
	theme.player = s.widgets.player

	-- init the bar
	s.wibar = awful.wibar({
		position = "top",
		screen = s,
		width = s.geometry.width * theme.wibar_width_ratio,
		bg = theme.full_transparent,
	})

	if screen.primary == s then
		-- set the wallpapers
		gears.wallpaper.maximized(theme.primary_wallpaper, s, false)

		-- set the tag table and taglist

		awful.tag({ "", "", "", "", "", "" }, s, awful.layout.suit.tile)

		-- setup the wibar for the primary screen
		s.wibar:setup({
			widget = wibox.container.margin,
			top = theme.wibar_top_margin,
			{
				bg = theme.wibar_bg,
				widget = wibox.container.background,
				shape = function(cr, w, h)
					gears.shape.rounded_rect(cr, w, h, theme.wibar_rad)
				end,

				{
					layout = wibox.layout.align.horizontal,
					expand = "inside",

					{
						layout = wibox.layout.fixed.horizontal,
						spacing = theme.wibar_spacing,
						{
							widget = wibox.container.constraint,
							strategy = "exact",
							width = theme.taglist_width,
							s.widgets.taglist,
						},

						{
							layout = wibox.layout.fixed.horizontal,
							{
								widget = wibox.container.constraint,
								strategy = "max",
								width = theme.systray_maxwidth,
								s.widgets.left_systray,
							},
						},

						player_widget,
					},

					{
						--layout = wibox.layout.fixed.horizontal,
						halign = "center",
						layout = wibox.container.place,

						{
							widget = wibox.container.constraint,
							strategy = "exact",
							width = theme.tasklist_width,
							s.widgets.tasklist,
						},
					},

					{
						layout = wibox.layout.fixed.horizontal,
						{
							widget = wibox.container.constraint,
							strategy = "max",
							width = theme.systray_maxwidth,
							s.widgets.right_systray,
						},
					},
				},
			},
		})
	else
		-- set the wallpapers
		gears.wallpaper.maximized(theme.secondary_wallpaper, s, false)

		-- tags
		awful.tag({ "", "", "", "", "", "" }, s, awful.layout.suit.tile)

		-- setup the wibar for the secondary screen
		s.wibar:setup({
			widget = wibox.container.margin,
			top = theme.wibar_top_margin,
			{
				bg = theme.wibar_bg,
				widget = wibox.container.background,
				shape = function(cr, w, h)
					gears.shape.rounded_rect(cr, w, h, theme.wibar_rad)
				end,

				{
					layout = wibox.layout.align.horizontal,
					expand = "none",

					{
						layout = wibox.layout.fixed.horizontal,
						spacing = theme.wibar_spacing,
						{
							widget = wibox.container.constraint,
							strategy = "exact",
							width = theme.taglist_width,
							s.widgets.taglist,
						},
					},

					{
						--layout = wibox.layout.fixed.horizontal,
						halign = "center",
						layout = wibox.container.place,

						{
							widget = wibox.container.constraint,
							strategy = "exact",
							width = theme.tasklist_width,
							s.widgets.tasklist,
						},
					},
				},
			},
		})
	end
end

return theme
