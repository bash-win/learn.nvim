-- Minimal init used to run the test suite in a clean Neovim.
local plenary_dir = os.getenv("PLENARY_DIR") or ".tests/plenary.nvim"

if vim.fn.isdirectory(plenary_dir) == 0 then
  vim.fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/nvim-lua/plenary.nvim",
    plenary_dir,
  })
end

-- Put the plugin under test (cwd) and plenary on the runtimepath.
vim.opt.runtimepath:append(".")
vim.opt.runtimepath:append(plenary_dir)

vim.cmd("runtime plugin/plenary.vim")
require("plenary.busted")
