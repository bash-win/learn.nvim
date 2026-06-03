describe("learn.ui", function()
  local ui = require("learn.ui")

  it("loads as a table", function()
    assert.is_table(ui)
  end)

  it("render_count sets the window winbar to the count", function()
    local win = vim.api.nvim_get_current_win()

    ui.render_count(win, 7)
    assert.equals("Keystrokes: 7", vim.wo[win].winbar)

    ui.render_count(win, 42)
    assert.equals("Keystrokes: 42", vim.wo[win].winbar)
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
end)
