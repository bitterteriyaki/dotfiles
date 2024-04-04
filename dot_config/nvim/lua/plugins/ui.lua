return {
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      require("lualine").setup()
    end,
  },
}
