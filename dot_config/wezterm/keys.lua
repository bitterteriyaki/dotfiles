local wezterm = require("wezterm")

return {
  -- Open a new tab
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
  -- Close the current tab
  {
    key = "w",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- Resize the current pane
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
  -- Focus the pane with a direction
  {
    key = "h",
    mods = "SHIFT",
    action = wezterm.action.ActivatePaneDirection "Left",
  },
  {
    key = "j",
    mods = "SHIFT",
    action = wezterm.action.ActivatePaneDirection "Down",
  },
  {
    key = "k",
    mods = "SHIFT",
    action = wezterm.action.ActivatePaneDirection "Up",
  },
  {
    key = "l",
    mods = "SHIFT",
    action = wezterm.action.ActivatePaneDirection "Right",
  },
}
