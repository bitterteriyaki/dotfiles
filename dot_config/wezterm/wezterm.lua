local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_prog = { "zellij" }

config.enable_tab_bar = false
config.enable_wayland = false

config.colors = {
  foreground = "#BFC6C1",
  background = "#111313",
}

return config
