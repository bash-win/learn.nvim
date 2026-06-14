return {
  title = "Move down with j",
  text = {
    "top",
    "down",
    "GOAL here",
    "more",
    "bottom",
  },
  goal = { type = "cursor", target = { line = 3, col = 0 } },
  par = 2,
  hints = {
    "Press j to move down one line.",
    "Stop on the GOAL line — don't overshoot.",
  },
}
