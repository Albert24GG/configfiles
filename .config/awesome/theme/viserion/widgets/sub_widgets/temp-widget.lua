
local cpu_temp_path = require("configuration.user-variables").cpu_temp_path
local wibox    = require("wibox")
local gears    = require("gears")
local awful    = require("awful")
local tonumber = tonumber

local function factory(args)
    args           = args or {}

    local temp     = { widget = args.widget or wibox.widget.textbox() }
    local timeout  = args.timeout or 30
    local format   = args.format or "%.1f"
    local settings = args.settings or function() end

    function temp.update()
        -- This path may change depending on the hardware
        awful.spawn.easy_async_with_shell("cat " .. cpu_temp_path, function(stdout)
            if stdout and stdout ~= "" then
                coretemp_now = tonumber(string.format(format, stdout/1000))
            else
                coretemp_now = "N/A"
            end
            widget = temp.widget
            settings()
        end)
    end

    local temp_timer = gears.timer.start_new(timeout, function() 
        temp.update()
        return true
    end)
    -- Cause timer to start immediately
    temp_timer:emit_signal("timeout")

    return temp
end

return factory
