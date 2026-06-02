describe("learn.session", function()
  local session = require("learn.session")

  after_each(function()
    session.stop()
  end)

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

  it("start() opens a read-only play buffer and marks the session active", function()
    session.start()

    assert.is_true(session.is_active())

    local play_buf = vim.api.nvim_get_current_buf()
    assert.is_true(vim.api.nvim_buf_is_valid(play_buf))

    local lines = vim.api.nvim_buf_get_lines(play_buf, 0, -1, false)
    assert.equals("Welcome to learn.nvim!", lines[1])

    assert.equals("nofile", vim.bo[play_buf].buftype)
    assert.is_false(vim.bo[play_buf].modifiable)
  end)

  it("stop() tears down the session with no leaked buffers or tabs", function()
    local function counts()
      return #vim.api.nvim_list_bufs(), #vim.api.nvim_list_tabpages()
    end

    local bufs_before, tabs_before = counts()

    session.start()
    local play_buf = vim.api.nvim_get_current_buf()
    assert.is_true(session.is_active())

    session.stop()

    assert.is_false(session.is_active())
    assert.is_false(vim.api.nvim_buf_is_valid(play_buf))

    local bufs_after, tabs_after = counts()
    assert.equals(bufs_before, bufs_after)
    assert.equals(tabs_before, tabs_after)
  end)
end)
