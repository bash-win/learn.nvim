local M = {}

function M.hello()
  vim.notify("Hello, world!", vim.log.levels.INFO, { title = "learn.nvim" })
end

function M.setup(opts)
  M.opts = opts or {}
end

function M.start()
  require("learn.session").start()
end

function M.stop()
  require("learn.session").stop()
end

return M
