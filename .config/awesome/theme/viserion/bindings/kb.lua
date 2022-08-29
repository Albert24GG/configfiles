local beautiful = require("beautiful")
local awful = require("awful")
local default_apps = require("configuration.user-variables").default_apps
local Modkey = require("configuration.user-variables").Modkey

-- Helper function
-- function to see if we should use clients directions to
-- jump between clients or use the tasklist order
local focusByTasklist = function(dir)
    local scr = awful.screen.focused()

    -- filter function: only check clients in current screen and tag
    local filter_cl_function = function(cl)
        if cl and cl.valid then
            for _, t in ipairs(cl:tags()) do
                if t == scr.selected_tag then
                    return true
                end
            end
        end
        return false
    end

    -- search for maximized or floating client
    local max_or_float = false
    local current_client = nil
    local cls = {}
    for c in awful.client.iterate(filter_cl_function, 0, scr) do
        cls[#cls + 1] = c
        max_or_float = c.maximized or c.floating or max_or_float
        current_client = c == client.focus and #cls or current_client
    end

    -- if we found a floating or maximized client we use tasklist order
    if current_client and max_or_float then
        local next_client = 1 + ((current_client + dir - 1) % #cls)
        cls[next_client]:jump_to()
        return true
    end

    -- otherwise use directions
    return false
end

awful.keyboard.append_global_keybindings {
    -------------------- Awesome Keys --------------------
    
    -- Reload awesome
    awful.key({ Modkey, "Control"},
                "s",
                awesome.restart,
                {description = "reload awesome", group = "Awesome", sort_order = 1}),

    -- Show help
    awful.key({ Modkey,},
                "s",
                function()
                    require("awful.hotkeys_popup").widget.new({width=965, height=500}):show_help()
                end,
                {description = "show help", group="Awesome", sort_order = 2}),

    -- Lock screen
    awful.key({Modkey,},
                "u",
                function ()
                    awful.spawn.with_shell("loginctl lock-session")
                end,
                {description = "lock screen", group = "Awesome", sort_order = 3}),

    -- Terminal   
    awful.key({ Modkey,},
                "Return",
                function ()
                    awful.spawn(default_apps.terminal)
                end,
                {description = "open a terminal", group = "Awesome", sort_order = 4}),

    -- Rofi launcher
    awful.key({ Modkey,},
                "r",
                function ()
                    awful.spawn.with_shell(default_apps.rofi_launcher_menu)
                end,
                {description = "run rofi in launcher mode", group = "Awesome", sort_order = 5}),

    -- Calculator
    awful.key({ Modkey,},
                "c",
                function ()
                    awful.spawn.with_shell(default_apps.calculator_app)
                end,
                {description = "open a calculator", group = "Awesome", sort_order = 6}),

    -- Full Screenshot
    awful.key({},
                "Print",
                function()
                    awful.spawn.with_shell(default_apps.full_screenshot)
                end,
                {description = "take a screenshot of the entire screen", group = "Awesome", sort_order = 7}),
    
    -- Area screenshot
    awful.key({Modkey, "Shift"},
                "s",
                function()
                    awful.spawn.with_shell(default_apps.area_screenshot)
                end,
                {description = "take an area screenshot", group = "Awesome", sort_order = 8}),

    -- Power options
    awful.key({ Modkey,},
                "p",
                function()
                    beautiful.power_center:power_center_show()
                end,
                {description = "show power options", group = "Awesome", sort_order = 9}),

    
    -- Open file manager
    awful.key({Modkey,},
                "f",
                function ()
                    awful.spawn.with_shell(default_apps.file_manager)
                end,
                {description = "open file explorer", group = "Awesome", sort_order = 10}),

    -- Emoji picker
    awful.key({ Modkey,},
                "e",
                function ()
                    awful.spawn(default_apps.emoji_picker)
                end,
                {description = "shows the emoji picker", group = "Awesome", sort_order = 11}),

    -- Web Browser
    awful.key({},
                "XF86HomePage",
                function ()
                    for c in awful.client.iterate(function () return true end) do
                        if c.class == "Firefox" then
                            c:jump_to()
                            return
                        end
                    end
                    awful.spawn(default_apps.browser)
                end,
                {description = "launches or jumps to the browser", group = "Awesome", sort_order = 14}),

    -------------------- Sound
    -- Toggle play-pause
    awful.key({},
                "XF86AudioPlay",
                function()
                    beautiful.player.toggle()
                end,
                {description = "play/pause music", group = "Sound", sort_order = 1}),

    -- Toggle next
    awful.key({},
                "XF86AudioNext",
                function()
                    beautiful.player.next()
                end,
                {description = "next music", group = "Sound", sort_order = 2}),

    -- Toggle prev
    awful.key({},
                "XF86AudioPrev",
                function()
                    beautiful.player.prev()
                end,
                {description = "prev music", group = "Sound", sort_order = 3}),

    -- Increase sound volume
    awful.key({},
                "XF86AudioRaiseVolume",
                function()
                    beautiful.volume.raise()
                end,
                {description = "raise sound volume", group = "Sound", sort_order = 4}),

    -- Lower sound volume
    awful.key({},
                "XF86AudioLowerVolume",
                function()
                    beautiful.volume.lower()
                end,
                {description = "lower sound volume", group = "Sound", sort_order = 5}),

    -- Toggle sound mute
    awful.key({},
                "XF86AudioMute",
                function()
                    beautiful.volume.toggle()
                end,
                {description = "toggle sound mute", group = "Sound", sort_order = 6}),

    -------------------- Screen navigation
    -- Switch screen
    awful.key({ Modkey,},
                "o",
                function ()
                    awful.screen.focus_relative(1)
                end,
                {description = "switch screen", group = "Screen", sort_order = 1}),

    -------------------- Tag navigation
    -- Prev tag
    awful.key({ Modkey,},
                "Left",
                awful.tag.viewprev,
                {description = "previous tag", group = "Tag", sort_order = 1}),

    -- Next tag
    awful.key({ Modkey,},
                "Right",
                awful.tag.viewnext,
                {description = "next tag", group = "Tag", sort_order = 2}),

    -- Alternate tag
    awful.key({ Modkey,},
                "Escape",
                awful.tag.history.restore,
                {description = "alternate tag", group = "Tag", sort_order = 3}),

    -- Change tag layout
    awful.key({ Modkey, "Ctrl"},
                "space",
                function ()
                    awful.layout.inc(1)
                end,
                {description = "change tag layout", group = "Tag", sort_order = 4}),

    -------------------- Client navigation
    -- Move focus one client up
    awful.key({ Modkey,},
                "k",
                function ()
                    awful.client.focus.bydirection("up")
                    if client.focus then
                        client.focus:raise()
                    end
                end,
                {description = "move focus to client up", group = "Client", sort_order = 1}),

    -- Move focus one client down
    awful.key({ Modkey,},
                "j",
                function ()
                    awful.client.focus.bydirection("down")
                    if client.focus then
                        client.focus:raise()
                    end
                end,
                {description = "move focus to client down", group = "Client", sort_order = 2}),

    -- Move focus one client right
    awful.key({ Modkey,},
                "l",
                function ()
                    if not focusByTasklist(1) then
                        awful.client.focus.bydirection("right")
                        if client.focus then
                            client.focus:raise()
                        end
                    end
                end,
                {description = "move focus to client right", group = "Client", sort_order = 3}),

    -- Move focus one client left
    awful.key({ Modkey,},
                "h",
                function ()
                    if not focusByTasklist(-1) then
                        awful.client.focus.bydirection("left")
                        if client.focus then
                            client.focus:raise()
                        end
                    end
                end,
                {description = "move focus to client left", group = "Client", sort_order = 4}),

    -- Alternate client
    awful.key({ Modkey,},
                "Tab",
                function ()
                    awful.client.focus.history.previous()
                    if client.focus then
                        client.focus:raise()
                    end
                end,
                {description = "alternate client", group = "Client", sort_order = 5}),

    -- Swap with client up
    awful.key({ Modkey, "Control"},
                "k",
                function ()
                    awful.client.swap.bydirection("up")
                end,
                {description = "swap with client up", group = "Client", sort_order = 6}),

    -- Swap with client down
    awful.key({ Modkey, "Control"},
                "j",
                function ()
                    awful.client.swap.bydirection("down")
                end,
                {description = "swap with client down", group = "Client", sort_order = 7}),

    -- Swap with client right
    awful.key({ Modkey, "Control"},
                "l",
                function ()
                    awful.client.swap.bydirection("right")
                end,
                {description = "swap with client right", group = "Client", sort_order = 8}),

    -- Swap with client left
    awful.key({ Modkey, "Control"},
                "h",
                function ()
                    awful.client.swap.bydirection("left")
                end,
                {description = "swap with client left", group = "Client", sort_order = 9}),

    -- Increase window factor of master client
    awful.key({ Modkey, "Shift"},
                "k",
                function ()
                    awful.tag.incmwfact(0.05)
                end,
                {description = "increase size of master client", group = "Client", sort_order = 10}),

    -- Decrease window factor of master client
    awful.key({ Modkey, "Shift"},
                "j",
                function ()
                    awful.tag.incmwfact(-0.05)
                end,
                {description = "decrease size of master client", group = "Client", sort_order = 11}),

    -- Increase window factor of non-master client
    awful.key({ Modkey, "Shift"},
                "l",
                function ()
                    awful.client.incwfact(0.05)
                end,
                {description = "increase size of non-master client", group = "Client", sort_order = 12}),

    -- Decrease window factor of non-master client
    awful.key({ Modkey, "Shift"},
                "h",
                function ()
                    awful.client.incwfact(-0.05)
                end,
                {description = "decrease size of non-master client", group = "Client", sort_order = 13}),

    -- Move floating client to the right
    awful.key({ Modkey, "Ctrl"},
                "Right",
                function ()
                    c = client.focus
                    if c and c.floating then
                        c:relative_move(10, 0, 0, 0)
                    end
                end,
                {description = "Move the focused floating client to the right", group = "Client", sort_order = 14}),

    -- Move floating client to the left
    awful.key({ Modkey, "Ctrl"},
                "Left",
                function ()
                    c = client.focus
                    if c and c.floating then
                        c:relative_move(-10, 0, 0, 0)
                    end
                end,
                {description = "Move the focused floating client to the left", group = "Client", sort_order = 15}),

    -- Move floating client up
    awful.key({ Modkey, "Ctrl"},
                "Up",
                function ()
                    c = client.focus
                    if c and c.floating then
                        c:relative_move(0, -10, 0, 0)
                    end
                end,
                {description = "Move the focused floating client up", group = "Client", sort_order = 16}),

    -- Move floating client down
    awful.key({ Modkey, "Ctrl"},
                "Down",
                function ()
                    c = client.focus
                    if c and c.floating then
                        c:relative_move(0, 10, 0, 0)
                    end
                end,
                {description = "Move the focused floating client down", group = "Client", sort_order = 17}),

    -- Increase floating client width
    awful.key({ Modkey, "Shift"},
                "Right",
                function ()
                    c = client.focus
                    if c and c.floating then
                        c:relative_move(0, 0, 10, 0)
                    end
                end,
                {description = "Increase floating client width", group = "Client", sort_order = 18}),

    -- Decrease floating client width
    awful.key({ Modkey, "Shift"},
                "Left",
                function ()
                    c = client.focus
                    if c and c.floating then
                        c:relative_move(0, 0, -10, 0)
                    end
                end,
                {description = "Decrease floating client width", group = "Client", sort_order = 19}),

    -- Increase floating client height
    awful.key({ Modkey, "Shift"},
                "Up",
                function ()
                    c = client.focus
                    if c and c.floating then
                        c:relative_move(0, 0, 0, -10)
                    end
                end,
                {description = "Increase floating client height", group = "Client", sort_order = 20}),

    -- Decrease floating client height
    awful.key({ Modkey, "Shift"},
                "Down",
                function ()
                    c = client.focus
                    if c and c.floating then
                        c:relative_move(0, 0, 0, 10)
                    end
                end,
                {description = "Decrease floating client height", group = "Client", sort_order = 21}),

    -- Switch to tag 1
    awful.key({ Modkey },
                "#10",
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[1]
                    if tag then
                        if screen.selected_tag == tag then
                            awful.tag.history.restore()
                        else
                            tag:view_only()
                        end
                    end
                end,
                {description = "switch to tag #1", group = "Tag", sort_order = 1 + 4}),

    -- Move client to tag 1
    awful.key({ Modkey, "Shift" },
                "#10",
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[1]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                   end
                end,
                {description = "move client to tag #1", group = "Tag", sort_order = 1 + 14}),

    -- Switch to tag 2
    awful.key({ Modkey },
                "#11",
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[2]
                    if tag then
                        if screen.selected_tag == tag then
                            awful.tag.history.restore()
                        else
                            tag:view_only()
                        end
                    end
                end,
                {description = "switch to tag #2", group = "Tag", sort_order = 2 + 4}),

    -- Move client to tag 2
    awful.key({ Modkey, "Shift" },
                "#11",
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[2]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                   end
                end,
                {description = "move client to tag #2", group = "Tag", sort_order = 2 + 14}),

    -- Switch to tag 3
    awful.key({ Modkey },
                "#12",
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[3]
                    if tag then
                        if screen.selected_tag == tag then
                            awful.tag.history.restore()
                        else
                            tag:view_only()
                        end
                    end
                end,
                {description = "switch to tag #3", group = "Tag", sort_order = 3 + 4}),

    -- Move client to tag 3
    awful.key({ Modkey, "Shift" },
                "#12",
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[3]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                   end
                end,
                {description = "move client to tag #3", group = "Tag", sort_order = 3 + 14}),

    -- Switch to tag 4
    awful.key({ Modkey },
                "#13",
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[4]
                    if tag then
                        if screen.selected_tag == tag then
                            awful.tag.history.restore()
                        else
                            tag:view_only()
                        end
                    end
                end,
                {description = "switch to tag #4", group = "Tag", sort_order = 4 + 4}),

    -- Move client to tag 4
    awful.key({ Modkey, "Shift" },
                "#13",
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[4]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                   end
                end,
                {description = "move client to tag #4", group = "Tag", sort_order = 4 + 14}),

    -- Switch to tag 5
    awful.key({ Modkey },
                "#14",
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[5]
                    if tag then
                        if screen.selected_tag == tag then
                            awful.tag.history.restore()
                        else
                            tag:view_only()
                        end
                    end
                end,
                {description = "switch to tag #5", group = "Tag", sort_order = 5 + 4}),

    -- Move client to tag 5
    awful.key({ Modkey, "Shift" },
                "#14",
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[5]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                   end
                end,
                {description = "move client to tag #5", group = "Tag", sort_order = 5 + 14}),

    -- Switch to tag 6
    awful.key({ Modkey },
                "#15",
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[6]
                    if tag then
                        if screen.selected_tag == tag then
                            awful.tag.history.restore()
                        else
                            tag:view_only()
                        end
                    end
                end,
                {description = "switch to tag #6", group = "Tag", sort_order = 6 + 4}),

    -- Move client to tag 6
    awful.key({ Modkey, "Shift" },
                "#15",
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[6]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                   end
                end,
                {description = "move client to tag #6", group = "Tag", sort_order = 6 + 14})
}

