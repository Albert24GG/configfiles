local ThemePath = require("configuration.user-variables").ThemePath

-- Global kb
require(ThemePath..".bindings.kb")

-- Client kb
require(ThemePath..".bindings.kb-client")

-- Client mouse
require(ThemePath..".bindings.mouse-client")
