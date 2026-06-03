-- Counts keystrokes during a lesson.
local M = {}

local count = 0
local counting = false

--- Current keystroke count.
---@return integer
function M.get()
  return count
end

--- Whether keystrokes are currently being counted.
---@return boolean
function M.is_counting()
  return counting
end

function M.start() end

function M.stop() end

function M.reset() end

return M
