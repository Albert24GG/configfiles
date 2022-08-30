local gears = require("gears")
local beautiful = require("beautiful")
local trans_cell_style = {bg_color = beautiful.full_transparent}
local user_variables = require("configuration.user-variables")
local ThemePath = user_variables.ThemePath


return {
    -- Volume
    volume = require(ThemePath.."widgets.sub_widgets.volume")(),

    -- Power options
    power_center = require(ThemePath.."widgets.sub_widgets.power_center")(),

    -- Brightness control widget
    brightness = require(ThemePath.."widgets.sub_widgets.brightness-widget")({
        program = user_variables.brightness_program,
        type = "icon_and_text"
    }),

    -- Calendar widget
    calendar = require(ThemePath .. "widgets.sub_widgets.calendar_widget")(),
    
    -- Todo list widget
    todo = require(ThemePath.."widgets.sub_widgets.todo-widget.todo")(),

    -- Weather widget
    weather = require(ThemePath.."widgets.sub_widgets.weather")({
        -- Api key is mandatory
        --api_key= "PATH/TO/openweathermap.org/API/KEY",
        api_key = user_variables.weather.api_key,
        coordinates = user_variables.weather.coordinates,
        font_name = user_variables.font.text,
        time_format_12h = false,
        units = 'metric',
        both_units_widget = false,
        icons = 'weather-underground-icons',
        show_hourly_forecast = true,
        show_daily_forecast = true,
    })
}
