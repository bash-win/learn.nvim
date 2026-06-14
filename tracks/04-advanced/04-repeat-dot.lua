return {
  title = "Repeat an edit with .",
  text = {
    "line one",
    "line two",
    "line three",
  },
  goal = {
    type = "content",
    expected = {
      "line one;",
      "line two;",
      "line three;",
    },
  },
  par = 7,
  hints = {
    "Make an edit once, then press . to repeat it.",
    "A; adds a semicolon at the end; then j. on each line.",
  },
}
