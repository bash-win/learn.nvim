-- Lesson schema and validation.
local M = {}

---@class learn.Lesson
---@field id string        assigned by the loader (filename stem)
---@field track string     assigned by the loader (folder name)
---@field title string
---@field text string[]
---@field goal learn.Goal
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

--- Validate an authored lesson table (before the loader assigns id/track).
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
  if candidate.goal.type ~= "cursor" then
    return false, "lesson.goal.type must be 'cursor'"
  end
  local target = candidate.goal.target
  if type(target) ~= "table" or type(target.line) ~= "number" or type(target.col) ~= "number" then
    return false, "lesson.goal.target must have numeric line and col"
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
