-- Loads lesson tracks from the filesystem.
local M = {}

local lesson = require("learn.lesson")

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

return M
