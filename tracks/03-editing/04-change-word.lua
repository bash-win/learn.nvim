return {
  title = "Change a word with cw",
  description = "cw deletes a word and enters insert mode.",
  text = { "change OLD word" },
  cursor = { line = 1, col = 7 },
  goal = { type = "content", expected = { "change new word" } },
  par = 6,
  hints = {
    "cw deletes the word and drops you into insert mode.",
    "Change OLD to new, then press Esc.",
  },
}
