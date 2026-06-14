-- The lifecycle of a single playthrough.
local M = {}

local counter = require("learn.counter")
local ui = require("learn.ui")
local goal = require("learn.goal")
local score = require("learn.score")
local loader = require("learn.loader")

local augroup = vim.api.nvim_create_augroup("learn.session", { clear = true })

local DEFAULT_PAR = 20

local HINT_KEY = "<F1>"

---@class learn.SessionState
---@field active boolean
---@field won boolean
---@field buffer integer|nil
---@field window integer|nil
---@field lesson learn.Lesson|nil
---@field hint_index integer
---@field completion { window: integer, buffer: integer }|nil
local state = {
  active = false,
  won = false,
  buffer = nil,
  window = nil,
  lesson = nil,
  hint_index = 0,
  completion = nil,
}

local function go_next()
  local next_lesson = loader.next_lesson(state.lesson)
  M.stop()
  if next_lesson ~= nil then
    M.start(next_lesson)
  end
end

local function restart()
  local lesson = state.lesson
  M.stop()
  if lesson ~= nil then
    M.start(lesson)
  end
end

local function handle_win()
  if not state.won or state.lesson == nil or state.completion ~= nil then
    return
  end
  vim.cmd("stopinsert")

  local keystrokes = counter.get()
  local par = state.lesson.par or DEFAULT_PAR
  local grade = score.evaluate(keystrokes, par)
  local has_next = loader.next_lesson(state.lesson) ~= nil

  state.completion = ui.show_completion({
    keystrokes = keystrokes,
    par = par,
    stars = grade.stars,
    label = grade.label,
    has_next = has_next,
  })

  vim.keymap.set("n", "q", M.stop, { buffer = state.completion.buffer, nowait = true })
  vim.keymap.set("n", "r", restart, { buffer = state.completion.buffer, nowait = true })
  if has_next then
    vim.keymap.set("n", "n", go_next, { buffer = state.completion.buffer, nowait = true })
  end
end

local function show_hint()
  counter.discount()
  if state.window ~= nil and vim.api.nvim_win_is_valid(state.window) then
    ui.render_status(state.window, state.lesson.description, counter.get())
  end

  local hints = state.lesson and state.lesson.hints
  if not hints or #hints == 0 then
    vim.notify("learn.nvim: no hints for this lesson", vim.log.levels.INFO)
    return
  end
  if state.hint_index >= #hints then
    vim.notify("learn.nvim: no more hints", vim.log.levels.INFO)
    return
  end
  state.hint_index = state.hint_index + 1
  ui.show_hint(state.hint_index, #hints, hints[state.hint_index])
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

--- Start a session for the given lesson, defaulting to the first built-in one.
---@param lesson learn.Lesson|nil
function M.start(lesson)
  if state.active then
    return
  end

  lesson = lesson or loader.default_lesson()
  if lesson == nil then
    vim.notify("learn.nvim: no lessons available", vim.log.levels.ERROR)
    return
  end

  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lesson.text)
  vim.bo[buffer].bufhidden = "wipe"
  vim.bo[buffer].filetype = "learn"
  vim.bo[buffer].modifiable = lesson.goal.type == "content"

  vim.keymap.set(
    "n",
    "q",
    M.stop,
    { buffer = buffer, nowait = true, desc = "learn.nvim: quit session" }
  )
  vim.keymap.set(
    "n",
    HINT_KEY,
    show_hint,
    { buffer = buffer, nowait = true, desc = "learn.nvim: show a hint" }
  )
  vim.keymap.set(
    "n",
    "<F2>",
    go_next,
    { buffer = buffer, nowait = true, desc = "learn.nvim: skip to the next lesson" }
  )

  vim.cmd.tabnew()
  local window = vim.api.nvim_get_current_win()
  local empty_buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(window, buffer)
  if vim.api.nvim_buf_is_valid(empty_buffer) then
    vim.api.nvim_buf_delete(empty_buffer, { force = true })
  end

  if lesson.cursor ~= nil then
    vim.api.nvim_win_set_cursor(window, { lesson.cursor.line, lesson.cursor.col })
  end

  state.buffer = buffer
  state.window = window
  state.lesson = lesson
  state.won = false
  state.hint_index = 0
  state.active = true

  if lesson.goal.type == "cursor" then
    ui.mark_target(buffer, lesson.goal.target)
  end

  counter.reset()
  ui.render_status(window, lesson.description, 0)
  counter.start(function(keystrokes)
    if vim.api.nvim_win_is_valid(window) then
      ui.render_status(window, lesson.description, keystrokes)
    end
  end)

  local events = lesson.goal.type == "content" and { "TextChanged", "TextChangedI" }
    or { "CursorMoved" }
  vim.api.nvim_create_autocmd(events, {
    group = augroup,
    buffer = buffer,
    callback = function()
      if state.won or state.lesson == nil then
        return
      end
      local cursor = vim.api.nvim_win_get_cursor(window)
      local context = {
        cursor = { line = cursor[1], col = cursor[2] },
        lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false),
      }
      if goal.is_reached(state.lesson.goal, context) then
        state.won = true
        counter.stop()
        vim.schedule(handle_win)
      end
    end,
  })
end

--- Stop the active session and tear down its play area.
function M.stop()
  counter.stop()
  vim.api.nvim_clear_autocmds({ group = augroup })
  if state.completion ~= nil and vim.api.nvim_win_is_valid(state.completion.window) then
    vim.api.nvim_win_close(state.completion.window, true)
  end
  if state.buffer ~= nil and vim.api.nvim_buf_is_valid(state.buffer) then
    ui.clear_target(state.buffer)
  end
  if state.window ~= nil and vim.api.nvim_win_is_valid(state.window) then
    -- Closing the window wipes the buffer (bufhidden=wipe) and closes its tab.
    vim.api.nvim_win_close(state.window, true)
  end
  state.active = false
  state.won = false
  state.buffer = nil
  state.window = nil
  state.lesson = nil
  state.hint_index = 0
  state.completion = nil
end

return M
