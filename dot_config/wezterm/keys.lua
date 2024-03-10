local wezterm = require("wezterm")

return {
  {
    key = "t",
    mods = "LEADER",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = "t",
    mods = "LEADER|SHIFT",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  {
    key = "h",
    mods = "CTRL|SHIFT",
    action = wezterm.action.AdjustPaneSize { 'Left', 1 },
  },
  {
    key = "j",
    mods = "CTRL|SHIFT",
    action = wezterm.action.AdjustPaneSize { 'Down', 1 },
  },
  {
    key = "k",
    mods = "CTRL|SHIFT",
    action = wezterm.action.AdjustPaneSize { 'Up', 1 },
  },
  {
    key = "l",
    mods = "CTRL|SHIFT",
    action = wezterm.action.AdjustPaneSize { 'Right', 1 },
  },
}
