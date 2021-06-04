return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      ensure_installed = { "lua_ls" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = vim.keymap.set

          map("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
          map("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
          map("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
          map("n", "gr", vim.lsp.buf.references, { buffer = event.buf })
          map("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf })
          map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf })
          map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf })
          map("n", "<leader>d", vim.diagnostic.open_float, { buffer = event.buf })
        end,
      })
    end,
  },
}
