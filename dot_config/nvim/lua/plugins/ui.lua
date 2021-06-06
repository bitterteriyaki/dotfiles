return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { globalstatus = true },
    },
  },

  -- UI for messages, cmdline and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {},
  },

  -- Indentation guides
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { enable = true, chars = { "┊" } },
      -- chunk = { enable = true },
      -- line_num = { enable = true },
      -- blank = { enable = false },
    },
  },
}
