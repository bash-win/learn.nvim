return {
  title = "Search backward with ?",
  text = {
    "the target is up here",
    "middle line",
    "down here",
  },
  cursor = { line = 3, col = 0 },
  goal = { type = "cursor", target = { line = 1, col = 4 } },
  par = 8,
  hints = {
    "Type ? then some text and press Enter to search backward.",
    "Search for 'target'.",
  },
}
