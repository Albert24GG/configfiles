local awful = require("awful")
local naughty = require("naughty")

-- Autostart programs

function run_if_not_running(program, arguments)
    awful.spawn.easy_async(
       "pgrep " .. program,
       function(stdout, stderr, reason, exit_code)
         --naughty.notify { text = stdout .. exit_code }
          if exit_code ~= 0 then
             awful.spawn.with_shell(program .. ' ' .. arguments)
          end
    end)
 end

 function run_apps(table)
  for _, t in ipairs(table) do
   run_if_not_running(t[1], t[2])
  end
end

local startup_apps = require("configuration.user-variables").startup_apps
run_apps(startup_apps)
