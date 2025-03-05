local blame_formatter = "<author> (<author_time:%d/%m/%Y>) | <summary>"

return {
  --
  -- Git signs
  --
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = blame_formatter,
      attach_to_untracked = true,
    },
  },
  --
  -- Indentation guides
  --
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local ibl = require("ibl")
      local hooks = require("ibl.hooks")
      local rd = require("rainbow-delimiters.setup")

      local highlight = {
        "RainbowMuted",
        "RainbowLove",
        "RainbowGold",
        "RainbowFoam",
        "RainbowRose",
        "RainbowPine",
        "RainbowIris",
      }

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowMuted", { fg = "#6e6a86" })
        vim.api.nvim_set_hl(0, "RainbowLove", { fg = "#b4637a" })
        vim.api.nvim_set_hl(0, "RainbowGold", { fg = "#ea9d34" })
        vim.api.nvim_set_hl(0, "RainbowFoam", { fg = "#56949f" })
        vim.api.nvim_set_hl(0, "RainbowRose", { fg = "#d7827e" })
        vim.api.nvim_set_hl(0, "RainbowPine", { fg = "#286983" })
        vim.api.nvim_set_hl(0, "RainbowIris", { fg = "#907aa9" })
      end)

      ibl.setup({
        indent = { char = "▏" },
        scope = { highlight = highlight, show_start = false, show_end = false },
      })
      rd.setup({ highlight = highlight })

      hooks.register(
        hooks.type.SCOPE_HIGHLIGHT,
        hooks.builtin.scope_highlight_from_extmark
      )
    end,
  },
  --
  -- Status line
  --
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    opts = {},
  },
  --
  -- Colorized brackets
  --
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
}
