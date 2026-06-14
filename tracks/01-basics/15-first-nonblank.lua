return {
  title = "First non-blank with ^",
  text = { "    target after the spaces" },
  cursor = { line = 1, col = 20 },
  goal = { type = "cursor", target = { line = 1, col = 4 } },
  par = 1,
  hints = {
    "Press ^ to jump to the first non-blank character.",
    "Unlike 0, it skips the leading spaces.",
  },
}
