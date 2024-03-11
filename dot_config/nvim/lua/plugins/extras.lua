return {
  -- Integration with Wakatime
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
  -- Discord Rich Presence
  {
    "andweeb/presence.nvim",
    event = "BufEnter",
    opts = { neovim_image_text = "Neovim" },
  },
}
