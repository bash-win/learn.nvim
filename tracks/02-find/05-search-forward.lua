return {
  title = "Search forward with /",
  description = "/ then text and Enter searches forward.",
  text = {
    "line one",
    "find the secret word",
    "line three",
  },
  goal = { type = "cursor", target = { line = 2, col = 9 } },
  par = 8,
  hints = {
    "Type / then some text and press Enter to search forward.",
    "Search for 'secret'.",
  },
}
