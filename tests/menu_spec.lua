describe("learn.menu", function()
  local menu = require("learn.menu")
  local loader = require("learn.loader")
  local session = require("learn.session")
  local fixtures = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/fixtures"

  local original_select = vim.ui.select

  after_each(function()
    session.stop()
    loader.set_user_tracks({})
    vim.ui.select = original_select
  end)

  it("starts the lesson chosen through the picker", function()
    loader.set_user_tracks({ fixtures .. "/sample" })
    vim.ui.select = function(items, _, on_choice)
      if items[1].lessons then
        for _, track in ipairs(items) do
          if track.id == "sample" then
            on_choice(track)
            return
          end
        end
      else
        on_choice(items[1])
      end
    end

    menu.open()

    assert.is_true(session.is_active())
    local lines = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, false)
    assert.equals("alpha", lines[1])
  end)

  it("does nothing when the picker is cancelled", function()
    vim.ui.select = function(_, _, on_choice)
      on_choice(nil)
    end

    menu.open()

    assert.is_false(session.is_active())
  end)
end)
