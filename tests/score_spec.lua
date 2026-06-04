describe("learn.score", function()
  local score = require("learn.score")

  it("loads and exposes evaluate", function()
    assert.is_table(score)
    assert.is_function(score.evaluate)
  end)

  it("awards three stars at or under par", function()
    assert.equals(3, score.evaluate(2, 5).stars)
    assert.equals(3, score.evaluate(5, 5).stars)
  end)

  it("awards two stars up to 1.5x par (inclusive)", function()
    assert.equals(2, score.evaluate(5, 4).stars)
    assert.equals(2, score.evaluate(6, 4).stars)
  end)

  it("awards one star beyond 1.5x par", function()
    assert.equals(1, score.evaluate(7, 4).stars)
    assert.equals(1, score.evaluate(100, 5).stars)
  end)

  it("includes a descriptive label", function()
    assert.is_string(score.evaluate(2, 5).label)
    assert.is_string(score.evaluate(100, 5).label)
  end)

  it("guards against a non-positive par", function()
    local result = score.evaluate(5, 0)
    assert.is_number(result.stars)
    assert.is_string(result.label)
  end)
end)
