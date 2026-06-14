return {
  title = "Find a character with f",
  description = "f then a character jumps onto its next occurrence.",
  text = { "find the X on this line" },
  goal = { type = "cursor", target = { line = 1, col = 9 } },
  par = 2,
  hints = {
    "Press f then a character to jump to its next occurrence.",
    "Type fX to land on the X.",
  },
}
