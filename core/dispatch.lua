--[[~ Updated: 2025/01/21 | Author(s): Gopher ]]
--
-- Backbone - An addon development framework for World of Warcraft.
--
--This program is free software: you can redistribute it and/or modify it under the terms
--of the GNU General Public License as published by the Free Software Foundation, either
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU General Public License <https://www.gnu.org/licenses/> for more details.

---
---@type table<number, backbone.task>
---
local tasks = {}

---
---@type Frame
---
local taskFrame = CreateFrame 'Frame'

---
---Execute tasks in a non-blocking manner.
---
taskFrame:SetScript(
  'OnUpdate', function()
    if tasks[1] ~= nil then
      local time_limit = 0.01667 -- 60 fps
      local time_started = GetTimePreciseSec()

      while tasks[1] ~= nil and (
          GetTimePreciseSec() - time_started < time_limit
        ) do
        backbone.executeTask(table.remove(tasks, 1))
      end
    end
  end
)

---
---@param task backbone.task
---@return unknown
---
backbone.executeTask = function(task)
  if type(task) ~= 'function' then
    throw('Expected `task` to be a function, got %s.', type(task))
  end
  local success, result = pcall(task)
  if not success then
    if backbone.isDevelopment() then
      local file, line, message = string.split(':', result --[[@as string]], 3)
      backbone.printf('<error>[Backbone]%s</end>', message)
      backbone.printf('%s (line %d)', file, line)
    else
      -- TODO: implement error handling in production mode.
      backbone.print 'Production mode error handling not implemented yet.'
    end
  end
  return result
end

---
---@param task backbone.task
---
backbone.queueTask = function(task)
  if type(task) ~= 'function' then
    throw('Expected `task` to be a function, got %s.', type(task))
  end
  array.append(tasks, task)
end
