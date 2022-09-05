local awful = require("awful")
--local naughty = require("naughty")

-- Autostart programs

function run_if_not_running(program)
    awful.spawn.easy_async(
       "pgrep -f " .. program,
       function(stdout, stderr, reason, exit_code)
          --naughty.notify { text = stdout .. exit_code }
          if exit_code ~= 0 then
             awful.spawn.with_shell(program)
          end
    end)
 end

 function run_apps(table)
  for _, t in ipairs(table) do
    run_if_not_running(t)
  end
end

local startup_apps = require("configuration.user-variables").startup_apps
run_apps(startup_apps)
