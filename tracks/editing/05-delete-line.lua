return {
  title = "Delete a line with dd",
  text = {
    "keep this",
    "delete this line",
    "keep this too",
  },
  cursor = { line = 2, col = 0 },
  goal = { type = "content", expected = { "keep this", "keep this too" } },
  par = 2,
  hints = {
    "dd deletes the whole current line.",
    "Remove the middle line.",
  },
}
