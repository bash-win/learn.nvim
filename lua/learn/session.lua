-- The lifecycle of a single playthrough.
local M = {}

local active = false

--- Report whether a lesson session is currently running.
---@return boolean
function M.is_active()
  return active
end

function M.start() end

function M.stop() end

return M
