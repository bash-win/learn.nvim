-- Renders lesson feedback into the play window.
local M = {}

local target_ns = vim.api.nvim_create_namespace("learn.ui.target")

vim.api.nvim_set_hl(0, "LearnTarget", { link = "IncSearch", default = true })

--- Show the keystroke count in the window's winbar.
---@param window integer
---@param count integer
function M.render_count(window, count)
  vim.wo[window].winbar = string.format("Keystrokes: %d", count)
end

--- Highlight the goal target cell in the buffer.
---@param buffer integer
---@param position learn.Pos
function M.mark_target(buffer, position)
  vim.api.nvim_buf_clear_namespace(buffer, target_ns, 0, -1)
  vim.api.nvim_buf_set_extmark(buffer, target_ns, position.line - 1, position.col, {
    end_col = position.col + 1,
    hl_group = "LearnTarget",
    strict = false,
  })
end

--- Remove the target highlight from the buffer.
---@param buffer integer
function M.clear_target(buffer)
  vim.api.nvim_buf_clear_namespace(buffer, target_ns, 0, -1)
end

return M
