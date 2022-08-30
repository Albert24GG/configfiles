local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local ruled = require('ruled')
local naughty = require('naughty')
local menubar = require('menubar')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local font_name = require("configuration.user-variables").font.text
local clickable_container = require(require("configuration.user-variables").ThemePath .. 'rules.clickable-container')


-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.timeout = 70
naughty.config.defaults.title = 'System Notification'
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = dpi(2)
naughty.config.defaults.position = 'top_right'

-- Apply theme variables
naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)
naughty.config.icon_dirs = {
	'/usr/share/icons/Papirus/',
	'/usr/share/icons/Tela',
	'/usr/share/icons/Tela-blue-dark',
	'/usr/share/icons/la-capitaine-icon-theme/',
	'/usr/share/icons/gnome/',
	'/usr/share/icons/hicolor/',
	'/usr/share/pixmaps/'
}
naughty.config.icon_formats = { 'svg', 'png', 'jpg', 'gif' }


-- Presets / rules

ruled.notification.connect_signal(
	'request::rules',
	function()

		-- Critical notifs
		ruled.notification.append_rule {
			rule       = { urgency = 'critical' },
			properties = { 
				font        		= font_name,
				bg 			= '#ff0000', 
				fg 			= '#ffffff',
				margin 			= dpi(16),
				position 		= 'top_right',
				implicit_timeout	= 5
			}
		}

		-- Normal notifs
		ruled.notification.append_rule {
			rule       = { urgency = 'normal' },
			properties = {
				font        		= font_name,
				bg      		= beautiful.transparent, 
				fg 			= beautiful.fg_normal,
				margin 			= dpi(16),
				position 		= 'top_right',
				implicit_timeout 	= 5
			}
		}

		-- Low notifs
		ruled.notification.append_rule {
			rule       = { urgency = 'low' },
			properties = { 
				font        		= font_name,
				bg     			= beautiful.transparent,
				fg 			= beautiful.fg_normal,
				margin 			= dpi(16),
				position 		= 'top_right',
				implicit_timeout	= 5
			}
		}
	end
)

-- XDG icon lookup
naughty.connect_signal(
	'request::icon',
	function(n, context, hints)
		if context ~= 'app_icon' then return end

		local path = menubar.utils.lookup_icon(hints.app_icon) or
		menubar.utils.lookup_icon(hints.app_icon:lower())

		if path then
			n.icon = path
		end
	end
)

-- Connect to naughty on display signal
naughty.connect_signal(
	'request::display',
	function(n)

		-- Actions Blueprint
		local actions_template = wibox.widget {
			notification = n,
			base_layout = wibox.widget {
				spacing        = dpi(0),
				layout         = wibox.layout.flex.horizontal
			},
			widget_template = {
				{
					{
						{
							{
								id     = 'text_role',
								font   = font_name,
								widget = wibox.widget.textbox
							},
							widget = wibox.container.place
						},
						widget = clickable_container
					},
					bg                 = beautiful.groups_bg,
					shape              = gears.shape.rounded_rect,
					forced_height      = dpi(30),
					widget             = wibox.container.background,
				},
				margins = dpi(4),
				widget  = wibox.container.margin,
			},
			style = { underline_normal = false, underline_selected = true },
			widget = naughty.list.actions
		}

		-- Notifbox Blueprint
		naughty.layout.box {
			notification = n,
			type = 'notification',
			screen = awful.screen.preferred(),
			widget_template = {
				{
					{
						{
							{
								{
									{
										{
											{
												{
													{
														markup = n.app_name or 'System Notification',
														font = font_name,
														align = 'center',
														valign = 'center',
														widget = wibox.widget.textbox

													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												bg = beautiful.background,
												widget  = wibox.container.background,
											},
											{
												{
													{
														resize_strategy = 'center',
														widget = naughty.widget.icon,
													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												{
													{
														layout = wibox.layout.align.vertical,
														expand = 'none',
														nil,
														{
															{
																align = 'left',
																widget = naughty.widget.title
															},
															{
																align = 'left',
																widget = naughty.widget.message,
															},
															layout = wibox.layout.fixed.vertical
														},
														nil
													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												layout = wibox.layout.fixed.horizontal,
											},
											fill_space = true,
											spacing = beautiful.notification_margin,
											layout  = wibox.layout.fixed.vertical,
										},
										-- Margin between the fake background
										-- Set to 0 to preserve the 'titlebar' effect
										margins = dpi(0),
										widget  = wibox.container.margin,
									},
									bg = beautiful.transparent,
									widget  = wibox.container.background,
								},
								-- Actions
								actions_template,
								spacing = dpi(4),
								layout  = wibox.layout.fixed.vertical,
							},
							bg     = beautiful.transparent,
							id     = 'background_role',
							widget = naughty.container.background,
						},
						strategy = 'min',
						width    = dpi(240),
						widget   = wibox.container.constraint,
					},
					strategy = 'max',
					width    = beautiful.notification_max_width or dpi(500),
					widget   = wibox.container.constraint
				},
				bg 				   = beautiful.background,
				widget 			   = wibox.container.background	
			}
		}
	end
)
