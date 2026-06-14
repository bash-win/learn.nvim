return {
  title = "Fix the typo",
  text = {
    'Fix the typo on the line below so it reads "hello, world".',
    "",
    "helo, world",
  },
  goal = {
    type = "content",
    expected = {
      'Fix the typo on the line below so it reads "hello, world".',
      "",
      "hello, world",
    },
  },
  par = 8,
  hints = {
    "Move onto the misspelled word, then fix it (e.g. cw to change it).",
    'It is missing an l — it should read "hello, world".',
  },
}
