local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Banana Blueberry"
config.window_padding = require("window_padding")

-- Cursor style
config.default_cursor_style = "BlinkingBar"
config.animation_fps = 60

-- Keybinding
config.leader = { key = "a", mods = "CTRL" }
config.keys = require("keys")

return config
