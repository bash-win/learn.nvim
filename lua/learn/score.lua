-- Scoring for a completed lesson.
local M = {}

local PERFECT_RATIO = 1.0
local GOOD_RATIO = 1.5

---@class learn.Score
---@field stars integer
---@field label string

--- Grade a finished lesson by keystrokes used against par.
---@param keystrokes integer
---@param par integer
---@return learn.Score
function M.evaluate(keystrokes, par)
    if par <= 0 then
        return { stars = 3, label = "Par or better!" }
    end

    local ratio = keystrokes / par
    if ratio <= PERFECT_RATIO then
        return { stars = 3, label = "Par or better!" }
    elseif ratio <= GOOD_RATIO then
        return { stars = 2, label = "Nicely done" }
    end
    return { stars = 1, label = "Keep practicing" }
end

return M
