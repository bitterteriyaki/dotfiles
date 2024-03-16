--
-- neovim settings
--
local default_settings = {
  -- mode
  showmode = false,
  -- colors
  termguicolors = true,
  -- indentation
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  -- cursor
  cursorline = true,
  -- line number
  number = true,
  numberwidth = 4,
  -- scroll-off
  wrap = false,
  scrolloff = 8,
  sidescrolloff = 8,
}

for k, v in pairs(default_settings) do
  vim.opt[k] = v
end

