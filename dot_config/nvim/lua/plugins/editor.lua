return {
  -- highlights texts that have changed since the last git commit, and also
  -- lets you interactively stage and unstage hunks in a commit
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = "<author> (<author_time:%d/%m/%Y>) - <summary>",
    },
  },
  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
