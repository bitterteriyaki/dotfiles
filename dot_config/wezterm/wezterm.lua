local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Banana Blueberry"

config.window_frame = {
  font = wezterm.font { family = "Cantarell", weight = "Bold" },
  font_size = 12.0,
}

return config

