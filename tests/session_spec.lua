describe("learn.session", function()
  local session = require("learn.session")
  local loader = require("learn.loader")
  local fixtures = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/fixtures"

  after_each(function()
    session.stop()
    loader.set_user_tracks({})
  end)

  local function counts()
    return #vim.api.nvim_list_bufs(), #vim.api.nvim_list_tabpages()
  end

  local function type_keys(keys)
    vim.api.nvim_feedkeys(keys, "nt", false)
    vim.api.nvim_feedkeys("", "x", false)
  end

  -- The completion screen is shown via vim.schedule; flush the loop before asserting on it.
  local function wait_for_float()
    vim.wait(500, function()
      for _, window in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(window).relative ~= "" then
          return true
        end
      end
      return false
    end)
  end

  it("loads as a table", function()
    assert.is_table(session)
  end)

  it("exposes the session API", function()
    assert.is_function(session.start)
    assert.is_function(session.stop)
    assert.is_function(session.is_active)
    assert.is_function(session.is_won)
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

  it("start() is a no-op when a session is already active", function()
    session.start()
    local play_buf = vim.api.nvim_get_current_buf()
    local bufs_before, tabs_before = counts()

    session.start()

    assert.is_true(session.is_active())
    assert.equals(play_buf, vim.api.nvim_get_current_buf())

    local bufs_after, tabs_after = counts()
    assert.equals(bufs_before, bufs_after)
    assert.equals(tabs_before, tabs_after)
  end)

  it("stop() is a safe no-op when no session is active", function()
    assert.is_false(session.is_active())
    assert.has_no.errors(function()
      session.stop()
    end)
    assert.is_false(session.is_active())
  end)

  it("maps q in the play buffer to quit the session", function()
    session.start()
    local play_buf = vim.api.nvim_get_current_buf()

    local mapped = false
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(play_buf, "n")) do
      if map.lhs == "q" then
        mapped = true
      end
    end
    assert.is_true(mapped)

    assert.is_true(session.is_active())
    vim.api.nvim_feedkeys("q", "x", false)
    assert.is_false(session.is_active())
  end)

  it("shows and updates the keystroke count while playing", function()
    local counter = require("learn.counter")
    session.start()
    local play_win = vim.api.nvim_get_current_win()

    assert.equals("Keystrokes: 0", vim.wo[play_win].winbar)
    assert.is_true(counter.is_counting())

    type_keys("ll")

    assert.equals(2, counter.get())
    assert.equals("Keystrokes: 2", vim.wo[play_win].winbar)

    session.stop()
    assert.is_false(counter.is_counting())
  end)

  it("fires a win when the cursor reaches the goal target", function()
    session.start()
    local play_win = vim.api.nvim_get_current_win()
    local play_buf = vim.api.nvim_get_current_buf()

    local function cursor_moved()
      vim.api.nvim_exec_autocmds("CursorMoved", { buffer = play_buf })
    end

    assert.is_false(session.is_won())

    vim.api.nvim_win_set_cursor(play_win, { 2, 0 })
    cursor_moved()
    assert.is_false(session.is_won())

    vim.api.nvim_win_set_cursor(play_win, { 4, 0 })
    cursor_moved()
    assert.is_true(session.is_won())
    assert.is_false(require("learn.counter").is_counting())
  end)

  it("highlights the goal target in the play buffer", function()
    session.start()
    local play_buf = vim.api.nvim_get_current_buf()

    local ns = vim.api.nvim_create_namespace("learn.ui.target")
    assert.is_true(#vim.api.nvim_buf_get_extmarks(play_buf, ns, 0, -1, {}) >= 1)
  end)

  it("shows a completion screen on win and closes it on stop", function()
    local function has_float()
      for _, window in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(window).relative ~= "" then
          return true
        end
      end
      return false
    end

    session.start()
    local play_win = vim.api.nvim_get_current_win()
    local play_buf = vim.api.nvim_get_current_buf()
    assert.is_false(has_float())

    vim.api.nvim_win_set_cursor(play_win, { 4, 0 })
    vim.api.nvim_exec_autocmds("CursorMoved", { buffer = play_buf })
    wait_for_float()
    assert.is_true(has_float())

    session.stop()
    assert.is_false(has_float())
  end)

  it("plays a provided lesson instead of the default", function()
    session.start({
      title = "Custom",
      text = { "custom line one", "custom line two" },
      goal = { type = "cursor", target = { line = 2, col = 0 } },
      par = 1,
    })

    local lines = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, false)
    assert.equals("custom line one", lines[1])
    assert.equals(2, #lines)
  end)

  it("advances to the next lesson with n on the end screen", function()
    loader.set_user_tracks({ fixtures .. "/sample" })
    local track = loader.load_track(fixtures .. "/sample")

    session.start(track.lessons[1])
    local play_win = vim.api.nvim_get_current_win()
    local play_buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_win_set_cursor(play_win, { 2, 0 })
    vim.api.nvim_exec_autocmds("CursorMoved", { buffer = play_buf })
    assert.is_true(session.is_won())
    wait_for_float()

    local advance
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(vim.api.nvim_get_current_buf(), "n")) do
      if map.lhs == "n" then
        advance = map.callback
      end
    end
    assert.is_function(advance)
    advance()

    local lines = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, false)
    assert.equals("gamma", lines[1])
  end)

  it("offers only quit on the last lesson of a track", function()
    loader.set_user_tracks({ fixtures .. "/sample" })
    local track = loader.load_track(fixtures .. "/sample")

    session.start(track.lessons[2])
    local play_win = vim.api.nvim_get_current_win()
    local play_buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_win_set_cursor(play_win, { 1, 3 })
    vim.api.nvim_exec_autocmds("CursorMoved", { buffer = play_buf })
    assert.is_true(session.is_won())
    wait_for_float()

    local has_next_key = false
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(vim.api.nvim_get_current_buf(), "n")) do
      if map.lhs == "n" then
        has_next_key = true
      end
    end
    assert.is_false(has_next_key)
  end)

  it("wins a content lesson when the buffer matches expected (edit)", function()
    session.start({
      title = "Fix it",
      text = { "helo world" },
      goal = { type = "content", expected = { "hello world" } },
      par = 2,
    })
    local play_buf = vim.api.nvim_get_current_buf()

    assert.is_true(vim.bo[play_buf].modifiable)
    assert.is_false(session.is_won())

    vim.api.nvim_buf_set_lines(play_buf, 0, -1, false, { "hello world" })
    vim.api.nvim_exec_autocmds("TextChanged", { buffer = play_buf })

    assert.is_true(session.is_won())
  end)

  it("wins a content lesson when extra lines are deleted (delete)", function()
    session.start({
      title = "Delete the block",
      text = { "keep", "delete me", "delete me too" },
      goal = { type = "content", expected = { "keep" } },
    })
    local play_buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_lines(play_buf, 0, -1, false, { "keep" })
    vim.api.nvim_exec_autocmds("TextChanged", { buffer = play_buf })

    assert.is_true(session.is_won())
  end)
end)
