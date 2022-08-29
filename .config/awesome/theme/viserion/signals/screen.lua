-- Setup the theme for each screen
screen.connect_signal("request::desktop_decoration", require("beautiful").at_screen_connect)
