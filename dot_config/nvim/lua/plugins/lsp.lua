return {
  --
  -- Mason LSPConfig
  --
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      mason.setup()
      mason_lspconfig.setup({
        automatic_installation = true,
        handlers = {
          ["lua_ls"] = function()
            lspconfig["lua_ls"].setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              },
            })
          end,
          -- Default handler
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,
        },
      })
    end,
  },
  --
  -- Yuck
  --
  {
    "elkowar/yuck.vim",
  },
}
