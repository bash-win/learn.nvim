return {
  title = "Change up to a character",
  description = "ct then a character changes up to it and enters insert.",
  text = { "x = OLD;" },
  cursor = { line = 1, col = 4 },
  goal = { type = "content", expected = { "x = new;" } },
  par = 7,
  hints = {
    "ct; changes everything up to the next ; and drops you into insert.",
    "Change OLD to new, then press Esc.",
  },
}
