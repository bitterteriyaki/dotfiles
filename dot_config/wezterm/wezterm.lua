local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = { "zellij" }

config.enable_tab_bar = false
config.enable_wayland = false

return config
