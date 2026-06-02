std = "luajit"
cache = true
codes = true

read_globals = {
  "vim",
}

files["tests/"] = {
  read_globals = {
    "describe",
    "it",
    "before_each",
    "after_each",
    "pending",
  },
}
