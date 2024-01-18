local wezterm = require("wezterm")
local config = wezterm.config_builder()

--
-- Cursor style
--
config.default_cursor_style = "BlinkingBar"
config.animation_fps = 60

--
-- Keybinds
--
config.leader = { key = "a", mods = "CTRL" }
config.keys = require("keys")

--
-- Window padding
--
config.window_padding = require("window_padding")

--
-- Color scheme
--
config.color_scheme = "zenwritten_dark"

--
-- Underline
--
config.underline_position = "-3px"
config.underline_thickness = "2px"
-- Reset underline for the cursor
config.cursor_thickness = "1px"

return config
