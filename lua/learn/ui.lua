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

--- Show a lesson hint without stealing focus.
---@param index integer
---@param total integer
---@param text string
function M.show_hint(index, total, text)
  vim.notify(
    string.format("Hint %d/%d: %s", index, total, text),
    vim.log.levels.INFO,
    { title = "learn.nvim" }
  )
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

local TOTAL_STARS = 3

local function completion_lines(summary)
  local stars = string.rep("★", summary.stars) .. string.rep("☆", TOTAL_STARS - summary.stars)
  local lines = {
    "Lesson complete!",
    "",
    string.format("Keystrokes: %d   (par: %d)", summary.keystrokes, summary.par),
    string.format("%s  %s", stars, summary.label),
    "",
  }
  if summary.has_next then
    table.insert(lines, "n: next lesson    q: quit")
  else
    table.insert(lines, "Track complete!")
    table.insert(lines, "q: quit")
  end
  return lines
end

--- Show a centered completion summary in a floating window.
---@param summary { keystrokes: integer, par: integer, stars: integer, label: string, has_next: boolean }
---@return { window: integer, buffer: integer }
function M.show_completion(summary)
  local lines = completion_lines(summary)

  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end

  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].modifiable = false
  vim.bo[buffer].bufhidden = "wipe"

  local window = vim.api.nvim_open_win(buffer, true, {
    relative = "editor",
    width = width + 2,
    height = #lines,
    row = math.floor((vim.o.lines - #lines) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })

  return { window = window, buffer = buffer }
end

return M
