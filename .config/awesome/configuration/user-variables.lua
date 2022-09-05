
return{
    -- Fonts used for text/icons (leave a space at the end of the string)
    font = { 
        text = "Source Code Pro, Medium ",
        icon = "Liberation Mono, Regular "
    },

    weather = {
        -- Path to the api key file
        api_key= "/home/albert/.config/openweathermap/api_key",
        
        -- The coordinates of your location
        coordinates = {44.4581844, 26.0791572}
    },

    -- Relative path to folder containing all related theme files
    ThemePath = "theme.viserion.",

    -- The exact name of the icon theme to be used
    icon_theme = "Papirus-Dark",
    
    -- Set the mod key
    Modkey = "Mod4",

    wallpaper = {
        -- Path to wallpapers
        primary_screen = "~/.config/awesome/theme/viserion/wallpapers/wallpaper-primary.jpg",
        secondary_screen = "~/.config/awesome/theme/viserion/wallpapers/wallpaper-primary.jpg"
    },
    
    -- Default apps used
    default_apps = {
        
        terminal = "kitty",
        rofi_launcher_menu = "rofi -combi-modi drun,window -modi combi -show combi -theme ~/.config/rofi/theme.rasi",
        calculator_app = "gnome-calculator --mode=advanced",
        file_manager = "thunar",
        emoji_picker = "emoji-picker",
        browser = "firefox",
        sound_control_gui = "pavucontrol",
        full_screenshot = "~/.config/awesome/utils/screenshot.sh full",
        area_screenshot = "~/.config/awesome/utils/screenshot.sh area"

    },

    -- Where to find the cpu temperature
    cpu_temp_path = "/sys/class/hwmon/hwmon2/temp1_input",

    -- The utility used for changing brightness (brightnessctl/xbacklight/light)
    brightness_program = "brightnessctl", 

    -- The programs that should be run at startup
    startup_apps = {
        "blueman-applet",
        "nm-applet",
        "xss-lock --transfer-sleep-lock -- betterlockscreen -l dimblur --span",
        "xautolock -time 5 -locker \'betterlockscreen -l dimblur --span\' -notify 15 -notifier \"notify-send \'Screen will lock in 15 s\'\" -detectsleep -killtime 20 -killer \"systemctl suspend\"",
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
        "picom -b",
        "redshift -l 44.4581844:26.0791572",
    }

}