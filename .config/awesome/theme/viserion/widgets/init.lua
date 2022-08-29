local ThemePath = require("configuration.user-variables").ThemePath

return function(s)
    return {
        taglist = require(ThemePath.."widgets.taglist"){scr = s},
        player = require(ThemePath.."widgets.player")(),
        tasklist = require(ThemePath.."widgets.tasklist"){scr = s},
        left_systray = require(ThemePath.."widgets.left-systray"){scr = s},
        right_systray = require(ThemePath.."widgets.right-systray"){scr = s},
        player = require(ThemePath .. "widgets.player")()
    }
end
