# learn.nvim

A Neovim plugin that teaches you Vim motions through mini-games.

## What it will be

An open-source engine that turns text files into Vim-motion practice games:

- Upload your own text files to create custom lessons
- Pre-built lessons that increase in difficulty

Each lesson tracks your keystrokes against a recommended budget and gives you a
final score for reaching, editing, or deleting a target in the text.

## Install

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "bash-win/learn.nvim",
  config = function()
    require("learn").setup()
  end,
}
```

## Usage

```vim
:LearnVim
```

Prints `Hello, world!`.
