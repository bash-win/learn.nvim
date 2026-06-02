describe("learn.session", function()
  local session = require("learn.session")

  it("loads as a table", function()
    assert.is_table(session)
  end)

  it("exposes the session API", function()
    assert.is_function(session.start)
    assert.is_function(session.stop)
    assert.is_function(session.is_active)
  end)

  it("is not active before a session starts", function()
    assert.is_false(session.is_active())
  end)
end)
