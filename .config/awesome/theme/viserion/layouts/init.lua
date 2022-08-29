--[[

     Lain
     Layouts, widgets and utilities for Awesome WM

     Layouts section

     Licensed under GNU General Public License v2
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann

--]]

local setmetatable = setmetatable

local wrequire = function (t, k)
      return rawget(t, k) or require(t._NAME .. '.' .. k)
end


local ThemePath = require("configuration.user-variables").ThemePath
local layout       = { _NAME = ThemePath .. "layouts" }

return setmetatable(layout, { __index = wrequire })
