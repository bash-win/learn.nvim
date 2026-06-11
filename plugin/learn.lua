if vim.g.loaded_learn then
  return
end
vim.g.loaded_learn = true

vim.api.nvim_create_user_command("LearnVim", function(cmd)
  local learn = require("learn")
  if cmd.args == "" then
    learn.menu()
    return
  end
  local track_id, lesson_id = cmd.args:match("^(.-)/(.+)$")
  local lesson = track_id and require("learn.loader").find_lesson(track_id, lesson_id)
  if lesson then
    learn.start(lesson)
  else
    vim.notify("learn.nvim: no lesson '" .. cmd.args .. "'", vim.log.levels.WARN)
  end
end, { nargs = "?", desc = "learn.nvim: open the lesson menu, or start <track>/<id>" })

vim.api.nvim_create_user_command("LearnVimQuit", function()
  require("learn").stop()
end, { desc = "learn.nvim: quit the current lesson session" })
