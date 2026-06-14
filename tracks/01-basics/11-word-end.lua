return {
  title = "End of word with e",
  description = "e jumps forward to the end of a word.",
  text = { "hop along the path" },
  goal = { type = "cursor", target = { line = 1, col = 8 } },
  par = 2,
  hints = {
    "Press e to jump to the end of the next word.",
    "Land on the last letter of 'along'.",
  },
}
