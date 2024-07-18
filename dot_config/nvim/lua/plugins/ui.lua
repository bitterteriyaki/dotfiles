return {
  -- Status bar
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      require("lualine").setup()
    end,
  },
}
