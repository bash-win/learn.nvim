describe("learn.goal", function()
  local goal = require("learn.goal")

  it("loads as a table", function()
    assert.is_table(goal)
  end)

  it("exposes is_reached", function()
    assert.is_function(goal.is_reached)
  end)

  it("cursor goal is reached when the cursor matches the target", function()
    local g = { type = "cursor", target = { line = 5, col = 10 } }
    assert.is_true(goal.is_reached(g, { cursor = { line = 5, col = 10 }, lines = {} }))
  end)

  it("cursor goal is not reached when the cursor differs", function()
    local g = { type = "cursor", target = { line = 5, col = 10 } }
    assert.is_false(goal.is_reached(g, { cursor = { line = 5, col = 9 }, lines = {} }))
    assert.is_false(goal.is_reached(g, { cursor = { line = 4, col = 10 }, lines = {} }))
  end)

  it("content goal is reached when the buffer matches expected", function()
    local g = { type = "content", expected = { "fixed", "lines" } }
    local context = { cursor = { line = 1, col = 0 }, lines = { "fixed", "lines" } }
    assert.is_true(goal.is_reached(g, context))
  end)

  it("content goal is not reached when the buffer differs", function()
    local g = { type = "content", expected = { "fixed", "lines" } }
    assert.is_false(goal.is_reached(g, { cursor = { line = 1, col = 0 }, lines = { "wrong", "lines" } }))
    assert.is_false(goal.is_reached(g, { cursor = { line = 1, col = 0 }, lines = { "fixed" } }))
  end)

  it("unknown goal types are never reached", function()
    local g = { type = "bogus" }
    assert.is_false(goal.is_reached(g, { cursor = { line = 1, col = 0 }, lines = {} }))
  end)
end)
