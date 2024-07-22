return {
  --
  -- Integration with GitHub Copilot
  --
  {
    "github/copilot.vim",
  },
  --
  -- Autopairs
  --
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
