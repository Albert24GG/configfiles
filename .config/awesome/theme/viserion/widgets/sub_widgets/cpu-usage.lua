--[[

     Licensed under GNU General Public License v2
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann

--]]

local wibox    = require("wibox")
local gears    = require("gears")
local math     = math
local string   = string


-- get a table with all lines from a file matching regexp
function lines_match(regexp, path)
    local lines = {}
    for line in io.lines(path) do
        if string.match(line, regexp) then
            lines[#lines + 1] = line
        end
    end
    return lines
end


-- CPU usage
-- lain.widget.cpu

local function factory(args)
    args           = args or {}

    local cpu      = { core = {}, widget = args.widget or wibox.widget.textbox() }
    local timeout  = args.timeout or 2
    local settings = args.settings or function() end

    function cpu.update()
        -- Read the amount of time the CPUs have spent performing
        -- different kinds of work. Read the first line of /proc/stat
        -- which is the sum of all CPUs.
        for index,time in pairs(lines_match("cpu","/proc/stat")) do
            local coreid = index - 1
            local core   = cpu.core[coreid] or
                           { last_active = 0 , last_total = 0, usage = 0 }
            local at     = 1
            local idle   = 0
            local total  = 0

            for field in string.gmatch(time, "[%s]+([^%s]+)") do
                -- 4 = idle, 5 = ioWait. Essentially, the CPUs have done
                -- nothing during these times.
                if at == 4 or at == 5 then
                    idle = idle + field
                end
                total = total + field
                at = at + 1
            end

            local active = total - idle

            if core.last_active ~= active or core.last_total ~= total then
                -- Read current data and calculate relative values.
                local dactive = active - core.last_active
                local dtotal  = total - core.last_total
                local usage   = math.floor(math.abs((dactive / dtotal) * 100))

                core.last_active = active
                core.last_total  = total
                core.usage       = usage

                -- Save current data for the next run.
                cpu.core[coreid] = core
            end
        end

        cpu_now = cpu.core
        cpu_now.usage = cpu_now[0].usage
        widget = cpu.widget

        settings()
    end

    local cpu_timer = gears.timer.start_new(timeout, function() 
        cpu.update()
        return true
    end)
    -- Cause timer to start immediately
    cpu_timer:emit_signal("timeout")

    return cpu
end

return factory
