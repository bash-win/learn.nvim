return {
  title = "Matching pair with %",
  description = "% jumps between a bracket and its match.",
  text = { "call(some, args) here" },
  cursor = { line = 1, col = 4 },
  goal = { type = "cursor", target = { line = 1, col = 15 } },
  par = 1,
  hints = {
    "With the cursor on a bracket, press % to jump to its match.",
    "Jump from the ( to its closing ).",
  },
}
