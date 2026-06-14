return {
  title = "Delete a character with x",
  text = { "keepX this" },
  cursor = { line = 1, col = 4 },
  goal = { type = "content", expected = { "keep this" } },
  par = 1,
  hints = {
    "Press x to delete the character under the cursor.",
    "Remove the stray X.",
  },
}
