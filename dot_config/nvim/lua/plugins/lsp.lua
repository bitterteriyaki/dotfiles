return {
  --
  -- Mason LSPConfig
  --
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      local cmp = require("cmp")
      local cmp_lsp = require("cmp_nvim_lsp")

      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
        },
      })

      local capabilities = cmp_lsp.default_capabilities()

      local config = {
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,
        },
      }

      mason.setup()
      mason_lspconfig.setup(config)
    end,
  },
}
