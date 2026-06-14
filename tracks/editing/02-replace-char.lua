return {
  title = "Replace a character with r",
  text = { "hella world" },
  cursor = { line = 1, col = 4 },
  goal = { type = "content", expected = { "hello world" } },
  par = 2,
  hints = {
    "Press r then a character to replace the one under the cursor.",
    "Replace the a with an o.",
  },
}
