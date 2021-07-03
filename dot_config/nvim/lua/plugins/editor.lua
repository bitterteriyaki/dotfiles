return {
  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = {
      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = { "%.git/" },
        },
      },
    },
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
      },
    },
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- Comment.nvim's own treesitter-based commentstring calculation
      -- crashes (indexing a nil parser) on filetypes without an installed
      -- treesitter parser, e.g. qml. Fall back to the native commentstring
      -- in that case to avoid ever reaching that code path.
      pre_hook = function()
        local ok, parser = pcall(vim.treesitter.get_parser, 0)
        if not ok or not parser then
          return vim.bo.commentstring
        end
      end,
    },
    config = function(_, opts)
      require("Comment").setup(opts)

      local api = require("Comment.api")

      vim.keymap.set("n", "<C-_>", api.toggle.linewise.current)
      vim.keymap.set("v", "<C-_>", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end)
    end,
  },
}
