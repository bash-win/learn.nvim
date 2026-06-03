-- Pure win-condition logic for a lesson goal.
local M = {}

---@class learn.Pos
---@field line integer 1-based line
---@field col integer 0-based column

---@class learn.Goal
---@field type "cursor"
---@field target learn.Pos

--- Whether the given cursor position satisfies the goal.
---@param goal learn.Goal
---@param pos learn.Pos
---@return boolean
function M.is_reached(goal, pos)
  if goal.type == "cursor" then
    return pos.line == goal.target.line and pos.col == goal.target.col
  end
  return false
end

return M
