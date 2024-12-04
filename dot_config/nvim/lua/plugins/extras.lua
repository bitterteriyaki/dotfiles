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
  --
  -- Support to Yuck language
  --
  {
    "elkowar/yuck.vim",
    config = function()
      vim.g.yuck_align_keywords = 0
      vim.g.yuck_list_indentation = 1
    end,
  },
}
