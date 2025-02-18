local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "nordfox"

config.font_size = 13.0
config.font = wezterm.font("CommitMono", { weight = "Bold" })

-- Tab bar settings
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.colors = {
	tab_bar = {
		background = "#2E3440",
		active_tab = {
			bg_color = "#5e81ac",
			fg_color = "#ECEFF4",
			intensity = "Normal",
			underline = "None",
		},
		inactive_tab = {
			bg_color = "#3B4252",
			fg_color = "#ECEFF4",
		},
		inactive_tab_hover = {
			bg_color = "#4C566A",
			fg_color = "#ECEFF4",
		},
	},
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	return {
		{ Text = string.format(" [%s] %s", tab.tab_index + 1, tab.active_pane.title) },
	}
end)

-- Keybindings
config.leader = { key = "a", mods = "CTRL" }
require("mux_keybinds").apply_to_config(config, {})

return config
