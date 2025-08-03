vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.fileencoding = "utf-8" -- Default the encoding to UTF-8
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 2 -- Number of spaces tabs count for
opt.shiftwidth = 2 -- Size of an indent
opt.cursorline = true -- Enable highlighting of the current line
opt.number = true -- Print line number
opt.numberwidth = 4 -- Set the line number width
opt.wrap = false -- Disable line wrap
opt.termguicolors = true -- True color support
opt.smoothscroll = true -- Enable smooth scrolling
opt.scrolloff = 4 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
