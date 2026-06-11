-- Loads lesson tracks from the filesystem.
local M = {}

local lesson = require("learn.lesson")

local user_track_dirs = {}

---@class learn.Track
---@field id string
---@field title string
---@field description string|nil
---@field lessons learn.Lesson[]

local function load_file(path)
  local chunk, load_err = loadfile(path)
  if not chunk then
    return nil, load_err
  end
  local ok, result = pcall(chunk)
  if not ok then
    return nil, result
  end
  return result
end

--- Load a single track folder into a Track. Lessons are ordered by filename;
--- invalid lesson files are skipped with a warning.
---@param dir string
---@return learn.Track
function M.load_track(dir)
  dir = dir:gsub("/$", "")
  local id = vim.fn.fnamemodify(dir, ":t")

  ---@type learn.Track
  local track = { id = id, title = id, description = nil, lessons = {} }

  local meta_path = dir .. "/track.lua"
  if vim.fn.filereadable(meta_path) == 1 then
    local meta = load_file(meta_path)
    if type(meta) == "table" then
      track.title = meta.title or id
      track.description = meta.description
    end
  end

  for _, name in ipairs(vim.fn.readdir(dir)) do
    if name:match("%.lua$") and name ~= "track.lua" then
      local path = dir .. "/" .. name
      local candidate, load_err = load_file(path)
      if candidate == nil then
        vim.notify(
          string.format("learn.nvim: could not load %s: %s", path, load_err),
          vim.log.levels.WARN
        )
      else
        local ok, validation_err = lesson.validate(candidate)
        if not ok then
          vim.notify(
            string.format("learn.nvim: invalid lesson %s: %s", path, validation_err),
            vim.log.levels.WARN
          )
        else
          candidate.id = name:gsub("%.lua$", "")
          candidate.track = id
          table.insert(track.lessons, candidate)
        end
      end
    end
  end

  return track
end

--- Register user-provided track folders. Each folder is loaded as one track.
---@param dirs string[]
function M.set_user_tracks(dirs)
  user_track_dirs = dirs or {}
end

--- Load every track: the built-in tracks plus any user-configured folders.
---@return learn.Track[]
function M.tracks()
  local tracks = {}

  local roots = vim.api.nvim_get_runtime_file("tracks", false)
  if #roots > 0 then
    for _, name in ipairs(vim.fn.readdir(roots[1])) do
      local dir = roots[1] .. "/" .. name
      if vim.fn.isdirectory(dir) == 1 then
        table.insert(tracks, M.load_track(dir))
      end
    end
  end

  for _, dir in ipairs(user_track_dirs) do
    local expanded = vim.fn.expand(dir)
    if vim.fn.isdirectory(expanded) == 1 then
      table.insert(tracks, M.load_track(expanded))
    else
      vim.notify("learn.nvim: track folder not found: " .. dir, vim.log.levels.WARN)
    end
  end

  return tracks
end

--- The first lesson of the first built-in track, used as a default.
---@return learn.Lesson|nil
function M.default_lesson()
  local tracks = M.tracks()
  if #tracks > 0 and #tracks[1].lessons > 0 then
    return tracks[1].lessons[1]
  end
  return nil
end

--- The lesson after the given one in its track, or nil if it is the last.
---@param current_lesson learn.Lesson
---@return learn.Lesson|nil
function M.next_lesson(current_lesson)
  for _, track in ipairs(M.tracks()) do
    if track.id == current_lesson.track then
      for index, candidate in ipairs(track.lessons) do
        if candidate.id == current_lesson.id then
          return track.lessons[index + 1]
        end
      end
    end
  end
  return nil
end

--- Find a lesson by its track id and lesson id, or nil.
---@param track_id string
---@param lesson_id string
---@return learn.Lesson|nil
function M.find_lesson(track_id, lesson_id)
  for _, track in ipairs(M.tracks()) do
    if track.id == track_id then
      for _, candidate in ipairs(track.lessons) do
        if candidate.id == lesson_id then
          return candidate
        end
      end
    end
  end
  return nil
end

return M
