local wezterm = require("wezterm")

return {
  -- Split the current tab:
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
  -- Close the current tab:
  {
    key = "w",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}

