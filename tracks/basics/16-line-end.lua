return {
  title = "Line end with $",
  text = { "go to the end of this line" },
  goal = { type = "cursor", target = { line = 1, col = 25 } },
  par = 1,
  hints = {
    "Press $ to jump to the end of the line.",
    "It lands on the last character.",
  },
}
