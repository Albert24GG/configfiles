local ThemePath = require("configuration.user-variables").ThemePath

-- Client rules
require(ThemePath..".rules.client")
-- Notification rules
require(ThemePath..".rules.notification")
