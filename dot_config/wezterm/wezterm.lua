local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.enable_wayland = false
config.enable_tab_bar = false

return config
