return {
  -- Integration with WakaTime
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
  -- Integration with Copilot
  {
    "github/copilot.vim",
  },
  -- Discord Rich Presence
  {
    "andweeb/presence.nvim",
    event = "BufEnter",
    opts = {
      neovim_image_text = "Neovim",
      main_image = "file",
    },
  },
}

