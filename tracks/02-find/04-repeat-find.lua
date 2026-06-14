return {
  title = "Repeat a find with ;",
  description = "; repeats the last f or t; , repeats it the other way.",
  text = { "a-b-c-d-e" },
  goal = { type = "cursor", target = { line = 1, col = 5 } },
  par = 4,
  hints = {
    "After an f, press ; to repeat it in the same direction.",
    "f- then ;; reaches the third dash.",
  },
}
