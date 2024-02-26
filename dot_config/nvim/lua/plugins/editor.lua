return {
  -- highlights texts that have changed since the last git commit, and also
  -- lets you interactively stage and unstage hunks in a commit
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_formatter = "<author> (<author_time:%d/%m/%Y>) - <summary>"
      })
    end,
  },
  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },
}
