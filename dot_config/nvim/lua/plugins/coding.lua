return {
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- WakaTime
  {
    "wakatime/vim-wakatime",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "enter" },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
