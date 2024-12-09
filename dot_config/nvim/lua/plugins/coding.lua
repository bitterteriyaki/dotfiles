return {
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
  -- nvim-cmp
  --
  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = { "hrsh7th/nvim-cmp", "neovim/nvim-lspconfig" },
  },
}
