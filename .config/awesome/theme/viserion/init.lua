local ThemePath = require("configuration.user-variables").ThemePath

-- Init the theme
require("beautiful").init(require(ThemePath.."theme"))

-- Set autofocus
require("awful.autofocus")

-- Rules
require(ThemePath.."rules")

-- Bindings
require(ThemePath.."bindings")

-- Signals
require(ThemePath.."signals")
