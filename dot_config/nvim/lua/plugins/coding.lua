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
  --
  -- Completion engine
  --
  {
    "hrsh7th/nvim-cmp",
    opts = {
      sources = {
        { name = "nvim_lsp" },
      },
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
}
