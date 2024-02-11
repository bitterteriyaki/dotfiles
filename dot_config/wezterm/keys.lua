local action = require("wezterm").action

return {
  --
  -- Split the current pane
  --
  {
    key = "t",
    mods = "LEADER",
    action = action.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = "t",
    mods = "LEADER|SHIFT",
    action = action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  --
  -- Resize the current pane
  --
  {
    key = "h",
    mods = "CTRL|SHIFT",
    action = action.AdjustPaneSize { "Left", 1 },
  },
  {
    key = "j",
    mods = "CTRL|SHIFT",
    action = action.AdjustPaneSize { "Down", 1 },
  },
  {
    key = "k",
    mods = "CTRL|SHIFT",
    action = action.AdjustPaneSize { "Up", 1 },
  },
  {
    key = "l",
    mods = "CTRL|SHIFT",
    action = action.AdjustPaneSize { "Right", 1 },
  },
  --
  -- Close the current pane
  --
  {
    key = "w",
    mods = "LEADER",
    action = action.CloseCurrentPane { confirm = true },
  },
  --
  -- Focus the pane in the given direction
  --
  {
    key = "h",
    mods = "CTRL",
    action = action.ActivatePaneDirection "Left",
  },
  {
    key = "j",
    mods = "CTRL",
    action = action.ActivatePaneDirection "Down",
  },
  {
    key = "k",
    mods = "CTRL",
    action = action.ActivatePaneDirection "Up",
  },
  {
    key = "l",
    mods = "CTRL",
    action = action.ActivatePaneDirection "Right",
  },
  --
  -- Swap the current pane with another pane
  --
  {
    key = "s",
    mods = "CTRL|SHIFT",
    action = action.PaneSelect { mode = "SwapWithActive" },
  },
}
