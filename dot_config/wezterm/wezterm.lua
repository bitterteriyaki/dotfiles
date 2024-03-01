local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night Moon"

config.window_padding = {
  left = 24,
  right = 24,
  top = 24,
  bottom = 24,
}

return config
