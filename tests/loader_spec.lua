describe("learn.loader", function()
  local loader = require("learn.loader")

  local here = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
  local fixtures = here .. "/fixtures"

  after_each(function()
    loader.set_user_tracks({})
  end)

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
    assert.is_true(#basics.lessons >= 2)
    assert.equals("01-intro", basics.lessons[1].id)

    local has_content_lesson = false
    for _, entry in ipairs(basics.lessons) do
      if entry.goal.type == "content" then
        has_content_lesson = true
      end
    end
    assert.is_true(has_content_lesson)
  end)

  it("default_lesson returns a valid lesson from a built-in track", function()
    local default = loader.default_lesson()
    assert.is_not_nil(default)
    assert.is_true((require("learn.lesson").validate(default)))
    assert.equals("basics", default.track)
  end)

  it("includes user-configured track folders alongside built-ins", function()
    loader.set_user_tracks({ fixtures .. "/sample" })

    local found
    for _, track in ipairs(loader.tracks()) do
      if track.id == "sample" then
        found = track
      end
    end

    assert.is_not_nil(found)
    assert.equals("Sample Track", found.title)
  end)

  it("next_lesson returns the following lesson, nil on the last", function()
    loader.set_user_tracks({ fixtures .. "/sample" })
    local track = loader.load_track(fixtures .. "/sample")

    local after_first = loader.next_lesson(track.lessons[1])
    assert.is_not_nil(after_first)
    assert.equals("02-second", after_first.id)

    assert.is_nil(loader.next_lesson(track.lessons[2]))
  end)

  it("find_lesson resolves a lesson by track and id", function()
    loader.set_user_tracks({ fixtures .. "/sample" })

    local found = loader.find_lesson("sample", "02-second")
    assert.is_not_nil(found)
    assert.equals("Second", found.title)

    assert.is_nil(loader.find_lesson("sample", "missing"))
    assert.is_nil(loader.find_lesson("missing", "02-second"))
  end)
end)
