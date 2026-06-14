return {
  title = "Move up with k",
  text = {
    "top",
    "GOAL: stop here",
    "three",
    "four",
    "five",
  },
  cursor = { line = 5, col = 0 },
  goal = { type = "cursor", target = { line = 2, col = 0 } },
  par = 3,
  hints = {
    "Press k to move up one line.",
    "Stop on the GOAL line, just below the top.",
  },
}
