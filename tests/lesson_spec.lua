describe("learn.lesson", function()
  local lesson = require("learn.lesson")

  local function valid()
    return {
      title = "Intro",
      text = { "line one", "line two" },
      goal = { type = "cursor", target = { line = 2, col = 0 } },
      par = 3,
    }
  end

  it("accepts a well-formed lesson", function()
    local ok, err = lesson.validate(valid())
    assert.is_true(ok)
    assert.is_nil(err)
  end)

  it("accepts a lesson without optional par/hints", function()
    local candidate = valid()
    candidate.par = nil
    assert.is_true((lesson.validate(candidate)))
  end)

  it("rejects a non-table", function()
    local ok, err = lesson.validate("nope")
    assert.is_false(ok)
    assert.is_string(err)
  end)

  it("rejects a missing or empty title", function()
    local candidate = valid()
    candidate.title = ""
    assert.is_false((lesson.validate(candidate)))
    candidate.title = nil
    assert.is_false((lesson.validate(candidate)))
  end)

  it("rejects text that is not a non-empty string list", function()
    local candidate = valid()
    candidate.text = {}
    assert.is_false((lesson.validate(candidate)))
    candidate.text = { 1, 2 }
    assert.is_false((lesson.validate(candidate)))
  end)

  it("accepts a content goal with an expected end-state", function()
    local candidate = valid()
    candidate.goal = { type = "content", expected = { "fixed", "lines" } }
    assert.is_true((lesson.validate(candidate)))
  end)

  it("rejects a malformed goal", function()
    local candidate = valid()

    candidate.goal = { type = "cursor" }
    assert.is_false((lesson.validate(candidate)))

    candidate.goal = { type = "content" }
    assert.is_false((lesson.validate(candidate)))

    candidate.goal = { type = "content", expected = {} }
    assert.is_false((lesson.validate(candidate)))

    candidate.goal = { type = "bogus" }
    assert.is_false((lesson.validate(candidate)))
  end)

  it("rejects a non-positive par", function()
    local candidate = valid()
    candidate.par = 0
    assert.is_false((lesson.validate(candidate)))
  end)

  it("rejects hints that are not a string list", function()
    local candidate = valid()
    candidate.hints = { 1 }
    assert.is_false((lesson.validate(candidate)))
  end)

  it("accepts an optional starting cursor", function()
    local candidate = valid()
    candidate.cursor = { line = 3, col = 2 }
    assert.is_true((lesson.validate(candidate)))
  end)

  it("rejects a malformed starting cursor", function()
    local candidate = valid()
    candidate.cursor = { line = 3 }
    assert.is_false((lesson.validate(candidate)))
  end)

  it("accepts an optional description", function()
    local candidate = valid()
    candidate.description = "h moves the cursor left"
    assert.is_true((lesson.validate(candidate)))
  end)

  it("rejects a non-string description", function()
    local candidate = valid()
    candidate.description = 5
    assert.is_false((lesson.validate(candidate)))
  end)
end)
