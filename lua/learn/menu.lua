-- Track and lesson picker.
local M = {}

local loader = require("learn.loader")
local session = require("learn.session")

--- Open an interactive picker: choose a track, then a lesson, then start it.
function M.open()
  local tracks = loader.tracks()
  if #tracks == 0 then
    vim.notify("learn.nvim: no tracks available", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(tracks, {
    prompt = "Select a track",
    format_item = function(track)
      return track.title
    end,
  }, function(track)
    if track == nil then
      return
    end
    vim.ui.select(track.lessons, {
      prompt = track.title .. " — select a lesson",
      format_item = function(lesson)
        return lesson.title
      end,
    }, function(lesson)
      if lesson ~= nil then
        session.start(lesson)
      end
    end)
  end)
end

return M
