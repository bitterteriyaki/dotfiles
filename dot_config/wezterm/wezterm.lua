local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Cursor styling
config.default_cursor_style = "BlinkingBar"
config.animation_fps = 60

-- Keybinding
config.leader = { key = "a", mods = "CTRL" }
config.keys = require("keys")

-- Underline cursor
config.underline_thickness = "2px"
config.underline_position = "-3px"
config.cursor_thickness = "1px"

return config
