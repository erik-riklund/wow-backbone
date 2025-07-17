--[[~ Updated: 2025/07/17 | Author(s): Gopher ]]
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
---A queue of tasks to be executed.
---
---@type table<number, backbone.task>
---
local tasks = {}

---
---A hidden UI frame used to trigger task processing on each game frame update.
---
---@type Frame
---
local taskFrame = CreateFrame 'Frame'

---
---This script runs every frame and attempts to execute tasks from the `tasks` queue
---for a maximum of `0.01667` seconds (approximately 60 frames per second) to prevent
---stuttering or hitches in the game.
---
---Tasks are removed from the queue as they are executed.
---
taskFrame:SetScript(
  'OnUpdate',

  function()
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
---Executes a given task function within a protected call (`pcall`).
---If the task execution fails, an error is printed to the chat.
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
      throw('?') -- this will trigger a generic error message.
    end
  end

  return result
end

---
---Adds a task (function) to the queue for deferred execution.
---
---@param task backbone.task
---
backbone.queueTask = function(task)
  if type(task) ~= 'function' then
    throw('Expected `task` to be a function, got %s.', type(task))
  end

  array.append(tasks, task)
end
