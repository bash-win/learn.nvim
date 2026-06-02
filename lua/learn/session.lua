-- The lifecycle of a single playthrough.
local M = {}

local active = false
local buf = nil
local win = nil

local PLACEHOLDER_TEXT = {
  "Welcome to learn.nvim!",
  "",
  "This is a practice buffer. Move around with h, j, k, and l.",
  "Soon, lessons will set you a goal and count your keystrokes.",
  "",
  "Press q to quit.",
}

--- Report whether a lesson session is currently running.
---@return boolean
function M.is_active()
  return active
end

function M.start()
  if active then
    return
  end

  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, PLACEHOLDER_TEXT)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "learn"
  vim.bo[buf].modifiable = false

  vim.cmd.tabnew()
  win = vim.api.nvim_get_current_win()
  local empty_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(win, buf)
  if vim.api.nvim_buf_is_valid(empty_buf) then
    vim.api.nvim_buf_delete(empty_buf, { force = true })
  end

  active = true
end

--- Stop the active session and tear down its play area.
function M.stop()
  if win ~= nil and vim.api.nvim_win_is_valid(win) then
    -- Closing the play window wipes the buffer (bufhidden=wipe) and, since the
    -- lesson lives in its own tab, closes that tab too.
    vim.api.nvim_win_close(win, true)
  end
  buf = nil
  win = nil
  active = false
end

return M
