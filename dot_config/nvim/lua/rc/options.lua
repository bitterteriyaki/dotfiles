local options = {
  backup = false,         -- do not create a backup file
  fileencoding = "utf-8", -- the file encoding
  termguicolors = true,   -- set term gui colors
  expandtab = true,       -- convert tab to spaces
  shiftwidth = 2,         -- the number of spaces inserted for each indentation
  tabstop = 2,            -- number of spaces for a tab
  cursorline = true,      -- highlight the current line
  number = true,          -- set numbered lines
  wrap = false,           -- do not wrap long lines
  scrolloff = 8,          -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,      -- minimal number of screen lines to keep left and right of the cursor
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
