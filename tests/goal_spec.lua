describe("learn.goal", function()
  local goal = require("learn.goal")

  it("loads as a table", function()
    assert.is_table(goal)
  end)

  it("exposes is_reached", function()
    assert.is_function(goal.is_reached)
  end)

  it("cursor goal is reached when the position matches the target", function()
    local g = { type = "cursor", target = { line = 5, col = 10 } }
    assert.is_true(goal.is_reached(g, { line = 5, col = 10 }))
  end)

  it("cursor goal is not reached when the position differs", function()
    local g = { type = "cursor", target = { line = 5, col = 10 } }
    assert.is_false(goal.is_reached(g, { line = 5, col = 9 }))
    assert.is_false(goal.is_reached(g, { line = 4, col = 10 }))
  end)

  it("unknown goal types are never reached", function()
    local g = { type = "content", target = { line = 1, col = 0 } }
    assert.is_false(goal.is_reached(g, { line = 1, col = 0 }))
  end)
end)
