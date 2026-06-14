return {
  title = "Bottom of file with G",
  description = "G jumps to the last line of the file.",
  text = {
    "one",
    "two",
    "three",
    "four",
    "the bottom line",
  },
  goal = { type = "cursor", target = { line = 5, col = 0 } },
  par = 1,
  hints = {
    "Press G to jump to the last line.",
    "It takes you to the very bottom.",
  },
}
