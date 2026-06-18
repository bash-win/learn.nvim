# learn.nvim

Learn Vim motions through scored mini-games, right inside Neovim.

Each lesson drops you into a practice buffer with a goal — reach a spot, or edit
the text into a target shape — and counts your keystrokes against a recommended
budget (par). Finish under par for three stars. Lessons are grouped into tracks
that build up from `hjkl` to operator + motion combos.

> Work in progress, but fully playable: four built-in tracks, 40 lessons.

## Requirements

- Neovim 0.9+

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

- `:LearnVim` — open the picker: choose a track, then a lesson.
- `:LearnVim <track>/<lesson>` — jump straight to a lesson, e.g. `:LearnVim basics/01-left`.
- `:LearnVimQuit` — quit the current session.

The winbar shows the lesson description and your live keystroke count.

### Keys

While playing a lesson:

| Key    | Action                    |
| ------ | ------------------------- |
| `<F1>` | show the next hint        |
| `<F2>` | skip to the next lesson   |
| `q`    | quit                      |

On the completion screen:

| Key | Action                |
| --- | --------------------- |
| `r` | restart the lesson    |
| `n` | next lesson           |
| `q` | quit                  |

## Built-in tracks

1. **The Basics** — `hjkl`, `w`/`b`/`e`, `0`/`^`/`$`, `gg`/`G`
2. **Find & Search** — `f`/`t`, `;`/`,`, `/`, `?`, `%`
3. **Editing** — `x`, `r`, `dw`, `cw`, `dd`, `ciw`, plus edit/delete challenges
4. **Advanced** — counts, operator + motion, the dot command, an efficiency challenge

## Custom tracks

A **track is a folder** and each **lesson is a file** in it, ordered by filename.
Point learn.nvim at your own track folders:

```lua
require("learn").setup({
  tracks = { "~/my-vim-lessons/jumps" },
})
```

A track folder may include an optional `track.lua` for its title:

```lua
-- ~/my-vim-lessons/jumps/track.lua
return { title = "My Jumps", description = "Personal practice." }
```

Each lesson file returns a table:

```lua
-- ~/my-vim-lessons/jumps/01-down.lua
return {
  title = "Move down with j",
  description = "j moves the cursor down a line.",  -- shown in the winbar
  text = {                                          -- the practice buffer
    "start here",
    "...",
    "land on this line",
  },
  goal = { type = "cursor", target = { line = 3, col = 0 } },
  -- content lessons instead match an end-state:
  -- goal = { type = "content", expected = { "the", "fixed", "lines" } },
  cursor = { line = 1, col = 0 },  -- optional starting cursor (default line 1, col 0)
  par = 2,                         -- optional keystroke budget
  hints = { "Press j to move down." },
}
```

Cursor positions use Neovim's convention: line is 1-based, column is 0-based.

## Development

```sh
make test    # run the test suite (plenary, headless)
make lint    # luacheck
make ci      # format check + lint + tests
```
