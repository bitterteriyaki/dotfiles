local M = {}

function M:init()
  local settings = require "modules.config.settings"
  settings.load_defaults()
end

return M

