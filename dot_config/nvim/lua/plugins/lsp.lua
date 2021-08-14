-- Language servers mason must keep installed.
local servers = {
  "lua_ls",
  "qmlls",
  "bashls",
  "jsonls",
  "yamlls",
  "marksman",
}

--- Registers the defaults every server inherits, then each per-server
--- override. Called from the nvim-lspconfig setup so that blink.cmp is
--- already loaded when its capabilities are read.
---@return nil
local function configure_servers()
  --- Settings applied on top of the shared defaults, keyed by the lspconfig
  --- server name. Servers absent from it run on their own defaults.
  ---@type table<string, vim.lsp.Config>
  local server_configs = {
    qmlls = {
      cmd = { "qmlls", "-E" },
    },
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    },
  }

  vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
  })

  for name, config in pairs(server_configs) do
    vim.lsp.config(name, config)
  end
end

--- Opens a floating window with the diagnostics of the current line whenever
--- the cursor rests on it, for a single buffer. How that window looks and
--- behaves comes from the `float` table of vim.diagnostic.config.
---@param bufnr integer Buffer a language server has attached to.
---@return nil
local function float_diagnostics_on_hold(bufnr)
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float()
    end,
  })
end

--- Highlights every occurrence of the symbol under the cursor while it rests
--- there, and clears the highlight as soon as it moves. Does nothing when the
--- server cannot answer documentHighlight requests.
---
--- Re-registering for the same buffer is safe: the buffer's own autocommands
--- are cleared first, so a server restart does not stack duplicates.
---@param client vim.lsp.Client? Server that attached, as given by LspAttach.
---@param bufnr integer Buffer a language server has attached to.
---@return nil
local function highlight_symbol_under_cursor(client, bufnr)
  local method = "textDocument/documentHighlight"

  if not client or not client:supports_method(method) then
    return
  end

  local group = vim.api.nvim_create_augroup("lsp_document_highlight", {
    clear = false,
  })

  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = bufnr,
    group = group,
    callback = vim.lsp.buf.document_highlight,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = bufnr,
    group = group,
    callback = vim.lsp.buf.clear_references,
  })
end

return {
  {
    "mason-org/mason.nvim",
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = { ensure_installed = servers },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      configure_servers()

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = false,
        float = {
          border = "rounded",
          focusable = false,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "\u{f057} ",
            [vim.diagnostic.severity.WARN] = "\u{f071} ",
            [vim.diagnostic.severity.INFO] = "\u{f05a} ",
            [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          float_diagnostics_on_hold(event.buf)
          highlight_symbol_under_cursor(client, event.buf)
        end,
      })
    end,
  },
}
