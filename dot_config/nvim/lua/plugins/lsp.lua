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

      vim.lsp.config("qmlls", {
        cmd = {
          "qmlls",
          "-I", "/usr/lib/qt6/qml",
          "-I", vim.fn.expand("~/.cache/quickshell-qmlls"),
        },
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

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client:supports_method("textDocument/documentHighlight") then
            local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })

            vim.api.nvim_clear_autocmds({ buffer = event.buf, group = group })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focusable = false })
        end,
      })
    end,
  },
}
