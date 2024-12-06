local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.enable_wayland = false

--
-- Multiplexing
--
config.enable_tab_bar = false
config.default_prog = { 'zellij' }

--
-- Cursor styling
--
config.default_cursor_style = "SteadyBar"
config.animation_fps = 60

--
-- Window padding
--
config.window_padding = {
  left = 20,
  right = 20,
  top = 20,
  bottom = 20,
}

--
-- Color scheme
--
config.colors = {
  background = '#130C0F'
}

return config
