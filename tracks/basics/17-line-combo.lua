return {
  title = "Line motions together",
  text = {
    "first line",
    "    second line indented",
  },
  goal = { type = "cursor", target = { line = 2, col = 4 } },
  par = 2,
  hints = {
    "Move down with j, then ^ to the first non-blank.",
    "Land on the start of the indented text.",
  },
}
