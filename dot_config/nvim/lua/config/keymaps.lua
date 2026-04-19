local map = vim.keymap.set

local telescope = require("telescope.builtin")

map("n", "<leader>ff", telescope.find_files, {})
map("n", "<leader>fg", telescope.live_grep, {})
map("n", "<leader>fh", telescope.help_tags, {})

map("n", "<leader>o", ":Neotree focus<CR>")
map("n", "<leader>r", ":Neotree reveal<CR>")
