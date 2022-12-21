local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local awful     = require("awful")
local math      = math
local naughty   = require("naughty")
local ThemePath = require("configuration.user-variables").ThemePath


return function(args)
    local args = args or {}
    local spc = args.spc or 13
    local scr = args.scr or screen.primary
    local innmar = args.innmar or 4
    local mar = args.mar or 0

    -- if this is not the primary screen, return empty wibox
    if scr ~= screen.primary then
        return widget.empty_wibox
    end

    local sub_widgets = require(ThemePath.."widgets.sub_widgets")
    local cpu_usage = require(ThemePath.."widgets.sub_widgets.cpu-usage")
    local temp_widget = require(ThemePath.."widgets.sub_widgets.temp-widget")
    local mem_widget = require(ThemePath.."widgets.sub_widgets.mem-widget")
    local bat_status_widget = require(ThemePath.."widgets.sub_widgets.bat-widget")
    local brightness_widget = require(ThemePath.."widgets.sub_widgets.brightness-widget")

    local cpu_load_widget = wibox.widget{ 
            widget = wibox.container.margin,
            margins = 0,
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = 3,

                {
                    id = "icon_widget",
                    widget = wibox.widget.textbox("礪"),
                    font = beautiful.icon_fontname .. 20
                },

                {
                    id = "textbox_widget",
                    widget = cpu_usage({ 
                        settings = function()
                          --widget:set_markup(string.format("%.2d%%", cpu_now.usage))
                          local usage = (cpu_now.usage < 10) and string.format(" %d%%", cpu_now.usage) or string.format("%d%%", cpu_now.usage)
                          widget:set_markup(usage)
                        end,
                      }).widget,
                },
            }
        }


    local cpu_widget = wibox.widget {
        cpu_load_widget,
        bottom = 2,
        color = beautiful.bg_normal,
        widget = wibox.container.margin
    }


    local temperature_widget = wibox.widget{
        widget = wibox.container.margin,
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 3,
        
            {
                id = "icon_widget",
                widget = wibox.widget.textbox(""),
                font = beautiful.icon_fontname .. 16
            },
        
            {
                id = "textbox_widget",
                widget = temp_widget({
                    settings = function()
                        if type(coretemp_now) == "number" then
                            local temp = (coretemp_now < 10) and string.format(" %.1f°", coretemp_now) or string.format("%.1f°", coretemp_now)
                            widget:set_markup(temp)
                        else
                            widget:set_markup(coretemp_now)
                        end
                    end,
                    timeout = 2
                }).widget
            },
        }
    }

    local ram_widget = wibox.widget{
        widget = wibox.container.margin,
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 3,
        
            {
                id = "icon_widget",
                widget = wibox.widget.textbox(""),
                font = beautiful.icon_fontname .. 16
            },
        
            {
                id = "textbox_widget",
                widget = mem_widget({
                    settings = function()
                        local usage = (mem_now.perc < 10) and string.format(" %d%%", mem_now.perc) or string.format("%d%%", mem_now.perc)
                        widget:set_markup(usage)
                    end,
                    timeout = 1
                }).widget
            },
        }
    }

    local bat_icon_widget = wibox.widget{
        widget = wibox.widget.textbox,
        font = beautiful.icon_fontname .. 11
    }

    local bat_perc_widget = bat_status_widget({
        settings = function()
            if bat_now.status and bat_now.status ~= "N/A" then
                local icons = {"", "", "", "", "", "", "", "", "", "", ""}
                local bat_icon = icons[2 + math.ceil(math.abs(tonumber(bat_now.perc) - 1) / 10)]
                if (bat_now.status == "Charging" or (bat_now.status == "Full" and bat_now.ac_status == 1)) then
                    bat_icon = bat_icon .. ""
                end
                bat_icon_widget:set_markup(bat_icon)    
                widget:set_markup(bat_now.perc)
            else
                local bat_icon = ""
                bat_icon_widget:set_markup(bat_icon)
                widget:set_markup(bat_now.perc)
            end
        end
    })

    local bat_widget = wibox.widget{
        widget = wibox.container.margin,
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 3,
            
            bat_icon_widget,
            bat_perc_widget
        }
    }

    return wibox.widget{
        widget = wibox.container.margin,
        margins = mar,
        right = -1,
        {

            layout = wibox.layout.fixed.horizontal,
            spacing = spc,
            {

                shape = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, beautiful.wibar_rad)
                end,
                bg = beautiful.wibar_systray_bg,
                widget = wibox.container.background

                {
                    widget = wibox.container.margin,
                    margins = innmar,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = spc,
                        
                        cpu_widget,
                        
                        temperature_widget,
                        
                        ram_widget,
                        
                        bat_widget,
                    }
                }
            },
        }
    }
end
