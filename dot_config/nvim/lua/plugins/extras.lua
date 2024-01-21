return {
  --
  -- Integration with WakaTime
  --
  {
    "wakatime/vim-wakatime",
  },
  --
  -- Discord Rich Presence
  --
  {
    "andweeb/presence.nvim",
    event = "BufEnter",
    opts = {
      neovim_image_text = "Neovim",
      main_image = "file",
    },
  },
}
