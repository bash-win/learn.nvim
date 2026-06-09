-- Pure win-condition logic for a lesson goal.
local M = {}

---@class learn.Pos
---@field line integer 1-based line
---@field col integer 0-based column

---@class learn.Goal
---@field type "cursor"|"content"
---@field target learn.Pos|nil cursor goals: the position to reach
---@field expected string[]|nil content goals: the buffer's expected end-state

---@class learn.GoalContext
---@field cursor learn.Pos
---@field lines string[]

local function lists_equal(a, b)
  if #a ~= #b then
    return false
  end
  for index = 1, #a do
    if a[index] ~= b[index] then
      return false
    end
  end
  return true
end

--- Whether the goal is satisfied by the current play context.
---@param goal learn.Goal
---@param context learn.GoalContext
---@return boolean
function M.is_reached(goal, context)
  if goal.type == "cursor" then
    return context.cursor.line == goal.target.line and context.cursor.col == goal.target.col
  elseif goal.type == "content" then
    return lists_equal(context.lines, goal.expected)
  end
  return false
end

return M
