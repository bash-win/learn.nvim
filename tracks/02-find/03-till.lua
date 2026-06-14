return {
  title = "Till a character with t",
  text = { "stop just before the dash - here" },
  goal = { type = "cursor", target = { line = 1, col = 25 } },
  par = 2,
  hints = {
    "t jumps just before the character (f lands on it).",
    "Type t- to stop right before the dash.",
  },
}
