-- Counts keystrokes during a lesson.
local M = {}

local count = 0
local counting = false
local ns = vim.api.nvim_create_namespace("learn.counter")

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

--- Begin counting keystrokes, calling `on_change(count)` after each key.
---@param on_change fun(count: integer)|nil
function M.start(on_change)
  if counting then
    return
  end
  vim.on_key(function()
    count = count + 1
    if on_change then
      on_change(count)
    end
  end, ns)
  counting = true
end

--- Stop counting keystrokes.
function M.stop()
  if not counting then
    return
  end
  vim.on_key(nil, ns)
  counting = false
end

--- Reset the keystroke count to zero.
function M.reset()
  count = 0
end

--- Subtract one from the count, e.g. to refund a non-lesson keypress.
function M.discount()
  if count > 0 then
    count = count - 1
  end
end

return M
