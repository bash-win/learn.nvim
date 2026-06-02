if vim.g.loaded_learn then
  return
end
vim.g.loaded_learn = true

vim.api.nvim_create_user_command("LearnVim", function()
  require("learn").hello()
end, { desc = "learn.nvim: print hello world" })
