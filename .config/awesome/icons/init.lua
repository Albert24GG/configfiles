local gears = require("gears")
local dir = gears.filesystem.get_configuration_dir() .. "icons"

return {
  --tags
  chrome = dir .. '/google-chrome.svg',
  code = dir .. '/code-braces.svg',
  social = dir .. '/forum.svg',
  folder = dir .. '/folder.svg',
  music = dir .. '/music.svg',
  game = dir .. '/google-controller.svg',
  lab = dir .. '/flask.svg',
  --others
  menu = dir .. '/menu.svg',
  close = dir .. '/close.svg',
  logout = dir .. '/logout.svg',
  sleep = dir .. '/power-sleep.svg',
  power = dir .. '/power.svg',
  lock = dir .. '/lock.svg',
  restart = dir .. '/restart.svg',
  search = dir .. '/magnify.svg',
  volume = dir .. '/volume-high.svg',
  brightness = dir .. '/brightness-7.svg',
  chart = dir .. '/chart-areaspline.svg',
  memory = dir .. '/memory.svg',
  harddisk = dir .. '/harddisk.svg',
  thermometer = dir .. '/thermometer.svg',
  plus = dir .. '/plus.svg',
  debian = dir .. '/debian-logo.png',
  new_email = dir .. '/new_email.png',
  default_app_icon = dir .. '/cs-default-applications.svg',
}