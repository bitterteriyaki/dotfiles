local opt = vim.opt

vim.g.mapleader = " "

if not vim.env.SSH_TTY then
  -- only set clipboard if not in ssh mode, to make sure the OSC 52 integration
  -- works automatically
  opt.clipboard = "unnamedplus" -- sync with system clipboard
end

opt.backup = false -- do not create a backup file
opt.fileencoding = "utf-8" -- the file encoding
opt.termguicolors = true -- set term gui colors
opt.expandtab =  true -- convert tabs to spaces
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.tabstop = 2 -- nuimber of spaces for a tab
opt.cursorline = true -- highlight the current selected line
opt.number = true -- set numbered lines
opt.numberwidth = 4 -- set the number column width to 4
opt.wrap = false -- do not wrap long lines
opt.scrolloff = 8 -- minimal number of screen lines to keep aobe and below the cursor
opt.sidescrolloff = 8 -- minimal number of screen lines to keep left and right of the cursor
opt.showmode = false -- do not show the default mode bar
opt.cmdheight = 1 -- space in the command line
opt.mouse = "a" -- enable mouse mode
