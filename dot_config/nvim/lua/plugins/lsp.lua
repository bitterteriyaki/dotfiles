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

      local config = {
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup()
          end,
        },
      }

      mason.setup()
      mason_lspconfig.setup(config)
    end,
  },
}
