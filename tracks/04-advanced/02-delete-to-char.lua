return {
  title = "Delete up to a character",
  text = { "drop everything up to | the bar" },
  goal = { type = "content", expected = { "| the bar" } },
  par = 3,
  hints = {
    "Combine an operator with a find: dt| deletes up to the bar.",
    "Everything before the | should go.",
  },
}
