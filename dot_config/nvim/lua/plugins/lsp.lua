return {
  -- LSPConfig
  {
    "neovim/nvim-lspconfig",
  },
  -- Mason
  {
    "williamboman/mason.nvim",
  },
  -- Mason LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup()
      mason_lspconfig.setup({
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({})
          end,
        },
      })
    end,
  },
}
