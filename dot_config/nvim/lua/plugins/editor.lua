return {
  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = {
      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = { "%.git/" },
        },
      },
    },
  },
}
