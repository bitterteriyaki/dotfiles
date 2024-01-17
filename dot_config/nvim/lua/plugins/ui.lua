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

      local highlight = { "RainbowRed" }

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#ff0000" })
      end)

      ibl.setup({
        indent = { char = "▏" },
        scope = { highlight = highlight },
      })
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
}
