describe("learn.ui", function()
  local ui = require("learn.ui")

  it("loads as a table", function()
    assert.is_table(ui)
  end)

  it("render_status shows the keystroke count, with an optional description", function()
    local win = vim.api.nvim_get_current_win()

    ui.render_status(win, nil, 7)
    assert.is_not_nil(vim.wo[win].winbar:find("Keystrokes: 7", 1, true))

    ui.render_status(win, "h moves left", 42)
    assert.is_not_nil(vim.wo[win].winbar:find("h moves left", 1, true))
    assert.is_not_nil(vim.wo[win].winbar:find("Keystrokes: 42", 1, true))
  end)

  it("mark_target highlights the target cell", function()
    local buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "hello", "world" })

    ui.mark_target(buffer, { line = 2, col = 0 })

    local ns = vim.api.nvim_create_namespace("learn.ui.target")
    local marks = vim.api.nvim_buf_get_extmarks(buffer, ns, 0, -1, { details = true })
    assert.equals(1, #marks)
    assert.equals(1, marks[1][2])
    assert.equals(0, marks[1][3])
    assert.equals("LearnTarget", marks[1][4].hl_group)
  end)

  it("clear_target removes the target highlight", function()
    local buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "hello" })

    ui.mark_target(buffer, { line = 1, col = 0 })
    ui.clear_target(buffer)

    local ns = vim.api.nvim_create_namespace("learn.ui.target")
    assert.equals(0, #vim.api.nvim_buf_get_extmarks(buffer, ns, 0, -1, {}))
  end)

  it("show_completion opens a centered float with the summary", function()
    local windows_before = #vim.api.nvim_list_wins()

    local completion = ui.show_completion({
      keystrokes = 5,
      par = 3,
      stars = 2,
      label = "Nicely done",
    })

    assert.is_true(vim.api.nvim_win_is_valid(completion.window))
    assert.equals("editor", vim.api.nvim_win_get_config(completion.window).relative)

    local text = table.concat(vim.api.nvim_buf_get_lines(completion.buffer, 0, -1, false), "\n")
    assert.is_not_nil(text:find("Keystrokes: 5", 1, true))
    assert.is_not_nil(text:find("par: 3", 1, true))
    assert.is_not_nil(text:find("Nicely done", 1, true))
    assert.is_not_nil(text:find("★★☆", 1, true))

    vim.api.nvim_win_close(completion.window, true)
    assert.equals(windows_before, #vim.api.nvim_list_wins())
  end)

  it("offers next/quit when a next lesson exists", function()
    local completion = ui.show_completion({
      keystrokes = 3,
      par = 3,
      stars = 3,
      label = "Par or better!",
      has_next = true,
    })

    local text = table.concat(vim.api.nvim_buf_get_lines(completion.buffer, 0, -1, false), "\n")
    assert.is_not_nil(text:find("n: next lesson", 1, true))

    vim.api.nvim_win_close(completion.window, true)
  end)

  it("shows track complete on the last lesson", function()
    local completion = ui.show_completion({
      keystrokes = 3,
      par = 3,
      stars = 3,
      label = "Par or better!",
      has_next = false,
    })

    local text = table.concat(vim.api.nvim_buf_get_lines(completion.buffer, 0, -1, false), "\n")
    assert.is_not_nil(text:find("Track complete!", 1, true))

    vim.api.nvim_win_close(completion.window, true)
  end)
end)
