describe("learn.loader", function()
  local loader = require("learn.loader")

  local here = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
  local fixtures = here .. "/fixtures"

  it("loads a track folder into ordered lessons with metadata", function()
    local track = loader.load_track(fixtures .. "/sample")

    assert.equals("sample", track.id)
    assert.equals("Sample Track", track.title)
    assert.equals("A track used by the loader tests.", track.description)

    assert.equals(2, #track.lessons)
    assert.equals("01-first", track.lessons[1].id)
    assert.equals("02-second", track.lessons[2].id)
    assert.equals("First", track.lessons[1].title)
    assert.equals("sample", track.lessons[1].track)
  end)

  it("falls back to the folder name and skips invalid lessons", function()
    local track = loader.load_track(fixtures .. "/bare")

    assert.equals("bare", track.id)
    assert.equals("bare", track.title)
    assert.equals(1, #track.lessons)
    assert.equals("01-only", track.lessons[1].id)
  end)

  it("loads the built-in basics track", function()
    local basics
    for _, track in ipairs(loader.tracks()) do
      if track.id == "basics" then
        basics = track
      end
    end

    assert.is_not_nil(basics)
    assert.equals("The Basics", basics.title)
    assert.is_true(#basics.lessons >= 1)
  end)

  it("default_lesson returns a valid lesson from a built-in track", function()
    local default = loader.default_lesson()
    assert.is_not_nil(default)
    assert.is_true((require("learn.lesson").validate(default)))
    assert.equals("basics", default.track)
  end)
end)
