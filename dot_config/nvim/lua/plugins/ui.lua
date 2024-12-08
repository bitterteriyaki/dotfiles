local blame_formatter = "<author> | (<author_time:%d/%m/%Y>) | <summary>"

return {
  --
  -- Git signs
  --
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = blame_formatter,
      attach_to_untracked = true,
    },
  },
  --
  -- Status line
  --
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    opts = {},
  },
}
