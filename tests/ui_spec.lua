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
end)
