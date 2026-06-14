return {
  title = "Change inner word with ciw",
  description = "ciw changes the entire word under the cursor.",
  text = { "fix the brokn word" },
  cursor = { line = 1, col = 10 },
  goal = { type = "content", expected = { "fix the broken word" } },
  par = 10,
  hints = {
    "ciw changes the whole word the cursor is on, from anywhere in it.",
    "Fix 'brokn' to 'broken', then press Esc.",
  },
}
