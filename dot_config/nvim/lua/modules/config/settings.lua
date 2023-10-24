local M = {}

M.load_default_options = function()
  local default_options = {
    backup = false,
    clipboard = "unnamedplus",
    cmdheight = 1,
    conceallevel = 0,
    fileencoding = "utf-8",
    hidden = true,
    mouse = "a",
    smartcase = true,
    splitbelow = true,
    splitright = true,
    termguicolors = true,
    title = true,
    undofile = true,
    expandtab = true,
    shiftwidth = 2,
    tabstop = 2,
    cursorline = true,
    number = true,
    numberwidth = 4,
    signcolumn = "yes",
    wrap = false,
    scrolloff = 8,
    sidescrolloff = 8,
  }

  for k, v in pairs(default_options) do
    vim.opt[k] = v
  end
end

M.load_defaults = function()
  M.load_default_options()
end

return M

