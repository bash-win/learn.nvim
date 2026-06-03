-- Renders lesson feedback into the play window.
local M = {}

--- Show the keystroke count in the window's winbar.
---@param win integer
---@param count integer
function M.render_count(win, count)
  vim.wo[win].winbar = string.format("Keystrokes: %d", count)
end

return M
