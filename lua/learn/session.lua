-- The lifecycle of a single playthrough.
local M = {}

local counter = require("learn.counter")
local ui = require("learn.ui")
local goal = require("learn.goal")

local augroup = vim.api.nvim_create_augroup("learn.session", { clear = true })

local PLACEHOLDER_TEXT = {
  "Welcome to learn.nvim!",
  "",
  "This is a practice buffer. Move around with h, j, k, and l.",
  "Soon, lessons will set you a goal and count your keystrokes.",
  "",
  "Press q to quit.",
}

local PLACEHOLDER_GOAL = { type = "cursor", target = { line = 4, col = 0 } }

---@class learn.SessionState
---@field active boolean
---@field won boolean
---@field buffer integer|nil
---@field window integer|nil
---@field goal learn.Goal|nil
local state = {
  active = false,
  won = false,
  buffer = nil,
  window = nil,
  goal = nil,
}

local function handle_win()
  state.won = true
end

--- Report whether a lesson session is currently running.
---@return boolean
function M.is_active()
  return state.active
end

--- Report whether the active session's goal has been reached.
---@return boolean
function M.is_won()
  return state.won
end

function M.start()
  if state.active then
    return
  end

  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, PLACEHOLDER_TEXT)
  vim.bo[buffer].bufhidden = "wipe"
  vim.bo[buffer].filetype = "learn"
  vim.bo[buffer].modifiable = false

  vim.keymap.set(
    "n",
    "q",
    M.stop,
    { buffer = buffer, nowait = true, desc = "learn.nvim: quit session" }
  )

  vim.cmd.tabnew()
  local window = vim.api.nvim_get_current_win()
  local empty_buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(window, buffer)
  if vim.api.nvim_buf_is_valid(empty_buffer) then
    vim.api.nvim_buf_delete(empty_buffer, { force = true })
  end

  state.buffer = buffer
  state.window = window
  state.goal = PLACEHOLDER_GOAL
  state.won = false
  state.active = true

  counter.reset()
  ui.render_count(window, 0)
  counter.start(function(keystrokes)
    if vim.api.nvim_win_is_valid(window) then
      ui.render_count(window, keystrokes)
    end
  end)

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = augroup,
    buffer = buffer,
    callback = function()
      if state.won or state.goal == nil then
        return
      end
      local cursor = vim.api.nvim_win_get_cursor(window)
      local position = { line = cursor[1], col = cursor[2] }
      if goal.is_reached(state.goal, position) then
        handle_win()
      end
    end,
  })
end

--- Stop the active session and tear down its play area.
function M.stop()
  counter.stop()
  vim.api.nvim_clear_autocmds({ group = augroup })
  if state.window ~= nil and vim.api.nvim_win_is_valid(state.window) then
    -- Closing the window wipes the buffer (bufhidden=wipe) and closes its tab.
    vim.api.nvim_win_close(state.window, true)
  end
  state.active = false
  state.won = false
  state.buffer = nil
  state.window = nil
  state.goal = nil
end

return M
