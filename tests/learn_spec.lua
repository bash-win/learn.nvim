describe("learn", function()
  local learn = require("learn")

  it("loads as a table", function()
    assert.is_table(learn)
  end)

  it("exposes the public API", function()
    assert.is_function(learn.setup)
    assert.is_function(learn.hello)
    assert.is_function(learn.start)
    assert.is_function(learn.stop)
  end)

  it("start()/stop() delegate to the session module", function()
    local session = require("learn.session")
    learn.start()
    assert.is_true(session.is_active())
    learn.stop()
    assert.is_false(session.is_active())
  end)

  it("setup() registers user track folders with the loader", function()
    local here = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
    local loader = require("learn.loader")

    learn.setup({ tracks = { here .. "/fixtures/sample" } })

    local found = false
    for _, track in ipairs(loader.tracks()) do
      if track.id == "sample" then
        found = true
      end
    end
    assert.is_true(found)

    loader.set_user_tracks({})
  end)

  it("hello() runs without error", function()
    assert.has_no.errors(function()
      learn.hello()
    end)
  end)

  it("setup() stores the given options", function()
    learn.setup({ greeting = "hi" })
    assert.is_table(learn.opts)
    assert.equals("hi", learn.opts.greeting)
  end)

  it("setup() tolerates no arguments", function()
    assert.has_no.errors(function()
      learn.setup()
    end)
    assert.is_table(learn.opts)
  end)
end)
