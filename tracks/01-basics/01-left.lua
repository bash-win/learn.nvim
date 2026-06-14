return {
  title = "Move left with h",
  description = "h moves the cursor one column to the left.",
  text = { "back to X now" },
  cursor = { line = 1, col = 12 },
  goal = { type = "cursor", target = { line = 1, col = 8 } },
  par = 4,
  hints = {
    "Press h to move one column to the left.",
    "Land on the X.",
  },
}
