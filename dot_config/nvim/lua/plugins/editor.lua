local blame_formatter = "<author> (<author_time:%d/%m/%Y>) | <summary>"

return {
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = blame_formatter,
      attach_to_untracked = true,
    },
  },
  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "▏" },
      })
    end,
  },
}
