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

return config
