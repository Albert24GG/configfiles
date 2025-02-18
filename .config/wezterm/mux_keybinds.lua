local M = {}

local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local search_direction = {
	BACKWARD = 0,
	FORWARD = 1,
}

wezterm.GLOBAL.tmux_search_directions = {}

M.action = {
	ClearPattern = wezterm.action_callback(function(window, pane)
		wezterm.GLOBAL.tmux_search_directions[tostring(pane)] = nil
		window:perform_action(
			act.Multiple({
				act.CopyMode("ClearPattern"),
				act.CopyMode("AcceptPattern"),
			}),
			pane
		)
	end),

	ClearSelectionOrClearPatternOrClose = wezterm.action_callback(function(window, pane)
		local action

		if window:get_selection_text_for_pane(pane) ~= "" then
			action = act.Multiple({
				act.ClearSelection,
				act.CopyMode("ClearSelectionMode"),
			})
		elseif wezterm.GLOBAL.tmux_search_directions[tostring(pane)] then
			action = M.action.ClearPattern
		else
			action = act.CopyMode("Close")
		end

		window:perform_action(action, pane)
	end),

	NextMatch = wezterm.action_callback(function(window, pane)
		local direction = wezterm.GLOBAL.tmux_search_directions[tostring(pane)]
		local action

		if not direction then
			return
		end

		if direction == search_direction.BACKWARD then
			action = act.Multiple({
				act.CopyMode("PriorMatch"),
				act.ClearSelection,
				act.CopyMode("ClearSelectionMode"),
			})
		elseif direction == search_direction.FORWARD then
			action = act.Multiple({
				act.CopyMode("NextMatch"),
				act.ClearSelection,
				act.CopyMode("ClearSelectionMode"),
			})
		end

		window:perform_action(action, pane)
	end),

	PriorMatch = wezterm.action_callback(function(window, pane)
		local direction = wezterm.GLOBAL.tmux_search_directions[tostring(pane)]
		local action

		if not direction then
			return
		end

		if direction == search_direction.BACKWARD then
			action = act.Multiple({
				act.CopyMode("NextMatch"),
				act.ClearSelection,
				act.CopyMode("ClearSelectionMode"),
			})
		elseif direction == search_direction.FORWARD then
			action = act.Multiple({
				act.CopyMode("PriorMatch"),
				act.ClearSelection,
				act.CopyMode("ClearSelectionMode"),
			})
		end

		window:perform_action(action, pane)
	end),

	MovePaneToNewTab = wezterm.action_callback(function(_, pane)
		local tab, _ = pane:move_to_new_tab()
		tab:activate()
	end),

	RenameWorkspace = wezterm.action_callback(function(window, pane)
		window:perform_action(
			act.PromptInputLine({
				description = "Rename workspace: ",
				action = wezterm.action_callback(function(_, _, line)
					if not line or line == "" then
						return
					end

					mux.rename_workspace(mux.get_active_workspace(), line)
				end),
			}),
			pane
		)
	end),

	SearchBackward = wezterm.action_callback(function(window, pane)
		wezterm.GLOBAL.tmux_search_directions[tostring(pane)] = search_direction.BACKWARD

		window:perform_action(
			act.Multiple({
				act.CopyMode("ClearPattern"),
				act.CopyMode("EditPattern"),
			}),
			pane
		)
	end),

	SearchForward = wezterm.action_callback(function(window, pane)
		wezterm.GLOBAL.tmux_search_directions[tostring(pane)] = search_direction.FORWARD

		window:perform_action(
			act.Multiple({
				act.CopyMode("ClearPattern"),
				act.CopyMode("EditPattern"),
			}),
			pane
		)
	end),

	WorkspaceSelect = wezterm.action_callback(function(window, pane)
		local active_workspace = mux.get_active_workspace()
		local workspaces = mux.get_workspace_names()
		local num_tabs_by_workspace = {}

		for _, mux_window in ipairs(mux.all_windows()) do
			local workspace = mux_window:get_workspace()
			local num_tabs = #mux_window:tabs()

			if num_tabs_by_workspace[workspace] then
				num_tabs_by_workspace[workspace] = num_tabs_by_workspace[workspace] + num_tabs
			else
				num_tabs_by_workspace[workspace] = num_tabs
			end
		end

		local choices = {
			{
				id = active_workspace,
				label = active_workspace .. ": " .. num_tabs_by_workspace[active_workspace] .. " tabs (active)",
			},
		}

		for _, workspace in ipairs(workspaces) do
			if workspace ~= active_workspace then
				table.insert(choices, {
					id = workspace,
					label = workspace .. ": " .. num_tabs_by_workspace[workspace] .. " tabs",
				})
			end
		end

		window:perform_action(
			act.InputSelector({
				title = "Select Workspace",
				choices = choices,
				action = wezterm.action_callback(function(_, _, id, _)
					if not id then
						return
					end

					mux.set_active_workspace(id)
				end),
			}),
			pane
		)
	end),
}

---@param config unknown
---@param _ { }
function M.apply_to_config(config, _)
	if not config.leader then
		config.leader = { key = "b", mods = "CTRL" }
		wezterm.log_warn("No leader key set, using default: Ctrl-b")
	end

	local keys = {
		{ key = config.leader.key, mods = "LEADER|" .. config.leader.mods, action = act.SendKey(config.leader) },

		-- Workspaces
		{ key = "$", mods = "LEADER|SHIFT", action = M.action.RenameWorkspace },
		{ key = "s", mods = "LEADER", action = M.action.WorkspaceSelect },
		{ key = "(", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(-1) },
		{ key = ")", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(1) },

		-- Tabs
		{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
		{
			key = "&",
			mods = "LEADER|SHIFT",
			action = act.CloseCurrentTab({ confirm = true }),
		},
		{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
		{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
		{ key = "l", mods = "LEADER", action = act.ActivateLastTab },
		{
			key = ",",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},

		-- Tab movement
		{ key = "<", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
		{ key = ">", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

		-- Panes

		-- Pane splitting
		{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

		{ key = "{", mods = "LEADER|SHIFT", action = act.RotatePanes("CounterClockwise") },
		{ key = "}", mods = "LEADER|SHIFT", action = act.RotatePanes("Clockwise") },

		-- Pane navigation
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "h", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "j", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "k", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
		{ key = "l", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Right") },

		{ key = "q", mods = "LEADER", action = act.PaneSelect({ mode = "Activate" }) },
		{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

		-- Pane movement
		{ key = "!", mods = "LEADER|SHIFT", action = M.action.MovePaneToNewTab },

		-- Pane resizing
		{
			key = "h",
			mods = "LEADER|SHIFT",
			action = act.Multiple({
				act.AdjustPaneSize({ "Left", 5 }),
				act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
			}),
		},
		{
			key = "j",
			mods = "LEADER|SHIFT",
			action = act.Multiple({
				act.AdjustPaneSize({ "Down", 5 }),
				act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
			}),
		},
		{
			key = "k",
			mods = "LEADER|SHIFT",
			action = act.Multiple({
				act.AdjustPaneSize({ "Up", 5 }),
				act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
			}),
		},
		{
			key = "l",
			mods = "LEADER|SHIFT",
			action = act.Multiple({
				act.AdjustPaneSize({ "Right", 5 }),
				act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
			}),
		},

		{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
		{ key = " ", mods = "LEADER", action = act.QuickSelect },

		-- Copy Mode
		{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	}

	-- Set up keybindings while resizing panes (to allow continuous resizing)
	local resize_pane = {
		{ key = "h", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "j", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "k", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "l", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "Escape", action = act.PopKeyTable },
	}

	-- Set up tab switching keybindings (up to 10 tabs)
	local index_offset = config.tab_and_split_indices_are_zero_based and 0 or 1
	for i = index_offset, 9 do
		table.insert(keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - index_offset) })
	end

	local copy_mode = {
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({
				act.CopyTo("Clipboard"),
				act.ClearSelection,
				act.CopyMode("ClearSelectionMode"),
				act.CopyMode("Close"),
			}),
		},
		{ key = "Escape", mods = "NONE", action = M.action.ClearSelectionOrClearPatternOrClose },
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "v", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "h", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
		{ key = "m", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "l", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },

		{ key = "/", mods = "NONE", action = M.action.SearchForward },
		{ key = "?", mods = "SHIFT", action = M.action.SearchBackward },
		{ key = "n", mods = "NONE", action = M.action.NextMatch },
		{ key = "N", mods = "SHIFT", action = M.action.PriorMatch },
	}

	local search_mode = {
		{
			key = "Enter",
			action = act.Multiple({
				act.CopyMode("AcceptPattern"),
				act.ClearSelection,
				act.CopyMode("ClearSelectionMode"),
			}),
		},
		{ key = "Escape", action = M.action.ClearPattern },
	}

	if not config.keys then
		config.keys = {}
	end
	for _, key in ipairs(keys) do
		table.insert(config.keys, key)
	end

	if not config.key_tables then
		config.key_tables = {}
	end

	if not config.key_tables.copy_mode then
		config.key_tables.copy_mode = {}
	end
	for _, key in ipairs(copy_mode) do
		table.insert(config.key_tables.copy_mode, key)
	end

	if not config.key_tables.search_mode then
		config.key_tables.search_mode = {}
	end
	for _, key in ipairs(search_mode) do
		table.insert(config.key_tables.search_mode, key)
	end

	if not config.key_tables.resize_pane then
		config.key_tables.resize_pane = {}
	end
	for _, key in ipairs(resize_pane) do
		table.insert(config.key_tables.resize_pane, key)
	end
end

return M
