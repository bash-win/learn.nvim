return {
  title = "Delete a word with dw",
  description = "dw deletes from the cursor to the next word.",
  text = { "delete this extra word here" },
  cursor = { line = 1, col = 12 },
  goal = { type = "content", expected = { "delete this word here" } },
  par = 2,
  hints = {
    "dw deletes from the cursor to the start of the next word.",
    "Remove the word 'extra'.",
  },
}
