local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Banana Blueberry"
config.window_padding = require("window_padding")

return config
