return {
  title = "Word forward with w",
  description = "w jumps forward to the start of the next word.",
  text = { "jump over these words please" },
  goal = { type = "cursor", target = { line = 1, col = 16 } },
  par = 3,
  hints = {
    "Press w to jump to the start of the next word.",
    "Land on the start of 'words'.",
  },
}
