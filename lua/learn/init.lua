local M = {}

function M.hello()
  vim.notify("Hello, world!", vim.log.levels.INFO, { title = "learn.nvim" })
end

function M.setup(opts)
  M.opts = opts or {}
  require("learn.loader").set_user_tracks(M.opts.tracks or {})
end

---@param lesson learn.Lesson|nil
function M.start(lesson)
  require("learn.session").start(lesson)
end

function M.stop()
  require("learn.session").stop()
end

return M
