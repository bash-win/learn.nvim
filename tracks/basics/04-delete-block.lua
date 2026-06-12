return {
  title = "Delete the block",
  text = {
    "Delete the two TODO lines below (try dd).",
    "",
    "keep this line",
    "TODO: remove me",
    "TODO: remove me too",
  },
  goal = {
    type = "content",
    expected = {
      "Delete the two TODO lines below (try dd).",
      "",
      "keep this line",
    },
  },
  par = 6,
  hints = {
    "Put the cursor on a TODO line and press dd to delete it.",
    "There are two TODO lines to remove.",
  },
}
