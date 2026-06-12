return {
  title = "End of line with $",
  text = {
    "Move your cursor onto the X using $ (jump to end of line).",
    "",
    "go to the end ->X",
  },
  goal = { type = "cursor", target = { line = 3, col = 16 } },
  par = 3,
  hints = {
    "First move down to the line with the X.",
    "Press $ to jump to the end of the current line.",
  },
}
