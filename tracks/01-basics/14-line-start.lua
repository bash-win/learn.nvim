return {
  title = "Line start with 0",
  text = { "press 0 to jump to column zero" },
  cursor = { line = 1, col = 15 },
  goal = { type = "cursor", target = { line = 1, col = 0 } },
  par = 1,
  hints = {
    "Press 0 to jump straight to the first column.",
    "It lands on the very start of the line.",
  },
}
