return {
  title = "Top of file with gg",
  description = "gg jumps to the first line of the file.",
  text = {
    "top of the file",
    "two",
    "three",
    "four",
    "five",
  },
  cursor = { line = 5, col = 0 },
  goal = { type = "cursor", target = { line = 1, col = 0 } },
  par = 2,
  hints = {
    "Press gg to jump to the first line.",
    "It takes you to the very top.",
  },
}
