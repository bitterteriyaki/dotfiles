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
    opts = function()
      local cmp = require("cmp")

      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
}
