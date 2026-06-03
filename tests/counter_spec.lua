describe("learn.counter", function()
  local counter = require("learn.counter")

  after_each(function()
    counter.stop()
    counter.reset()
  end)

  local function type_keys(keys)
    vim.api.nvim_feedkeys(keys, "nt", false)
    vim.api.nvim_feedkeys("", "x", false)
  end

  it("loads as a table", function()
    assert.is_table(counter)
  end)

  it("exposes the counter API", function()
    assert.is_function(counter.start)
    assert.is_function(counter.stop)
    assert.is_function(counter.reset)
    assert.is_function(counter.get)
    assert.is_function(counter.is_counting)
  end)

  it("starts at zero and not counting", function()
    assert.equals(0, counter.get())
    assert.is_false(counter.is_counting())
  end)

  it("counts one per keystroke while counting", function()
    counter.start()
    assert.is_true(counter.is_counting())

    type_keys("lll")

    assert.equals(3, counter.get())
  end)

  it("stops counting after stop()", function()
    counter.start()
    type_keys("ll")
    counter.stop()

    assert.is_false(counter.is_counting())
    local frozen = counter.get()

    type_keys("ll")
    assert.equals(frozen, counter.get())
  end)

  it("reset() zeroes the count", function()
    counter.start()
    type_keys("ll")
    counter.reset()
    assert.equals(0, counter.get())
  end)

  it("invokes the on_change hook with the running count", function()
    local seen = {}
    counter.start(function(c)
      table.insert(seen, c)
    end)

    type_keys("ll")

    assert.equals(2, #seen)
    assert.equals(1, seen[1])
    assert.equals(2, seen[2])
  end)
end)
