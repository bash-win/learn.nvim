-- Lesson schema and validation.
local M = {}

---@class learn.Lesson
---@field id string
---@field track string
---@field title string
---@field text string[]
---@field goal learn.Goal
---@field cursor learn.Pos|nil starting cursor position (default line 1, col 0)
---@field par integer|nil
---@field hints string[]|nil

local function is_string_list(value)
  if type(value) ~= "table" then
    return false
  end
  for _, item in ipairs(value) do
    if type(item) ~= "string" then
      return false
    end
  end
  return true
end

--- Validate an authored lesson table
---@param candidate any
---@return boolean ok
---@return string|nil err
function M.validate(candidate)
  if type(candidate) ~= "table" then
    return false, "lesson must be a table"
  end
  if type(candidate.title) ~= "string" or candidate.title == "" then
    return false, "lesson.title must be a non-empty string"
  end
  if not is_string_list(candidate.text) or #candidate.text == 0 then
    return false, "lesson.text must be a non-empty list of strings"
  end
  if type(candidate.goal) ~= "table" then
    return false, "lesson.goal must be a table"
  end
  local goal = candidate.goal
  if goal.type == "cursor" then
    local target = goal.target
    if type(target) ~= "table" or type(target.line) ~= "number" or type(target.col) ~= "number" then
      return false, "lesson.goal.target must have numeric line and col"
    end
  elseif goal.type == "content" then
    if not is_string_list(goal.expected) or #goal.expected == 0 then
      return false, "lesson.goal.expected must be a non-empty list of strings"
    end
  else
    return false, "lesson.goal.type must be 'cursor' or 'content'"
  end
  if candidate.cursor ~= nil then
    local cursor = candidate.cursor
    if type(cursor) ~= "table" or type(cursor.line) ~= "number" or type(cursor.col) ~= "number" then
      return false, "lesson.cursor must have numeric line and col when set"
    end
  end
  if candidate.par ~= nil and (type(candidate.par) ~= "number" or candidate.par <= 0) then
    return false, "lesson.par must be a positive number when set"
  end
  if candidate.hints ~= nil and not is_string_list(candidate.hints) then
    return false, "lesson.hints must be a list of strings when set"
  end
  return true
end

return M
