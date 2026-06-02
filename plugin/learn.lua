if vim.g.loaded_learn then
  return
end
vim.g.loaded_learn = true

vim.api.nvim_create_user_command("LearnVim", function()
  require("learn").start()
end, { desc = "learn.nvim: start a lesson session" })

vim.api.nvim_create_user_command("LearnVimQuit", function()
  require("learn").stop()
end, { desc = "learn.nvim: quit the current lesson session" })
