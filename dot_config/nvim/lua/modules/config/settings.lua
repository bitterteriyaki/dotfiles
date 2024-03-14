local M = {}

M.load_default_options = function()
  local default_options = {
    number = true,
    numberwidth = 4,
  }

  for k, v in pairs(default_options) do
    vim.opt[k] = v
  end
end

M.load_defaults = function()
  M.load_default_options()
end

return M

