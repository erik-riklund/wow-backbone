--[[~ Updated: 2025/01/07 | Author(s): Gopher ]]
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

local tasks = ({} --[[@as table<number, backbone.task>]])
local taskFrame = CreateFrame 'Frame' --[[@as Frame]]

---
---Invoke the provided callback in safe mode, gracefully handling any errors.
---
---@param task backbone.task
---
backbone.executeTask = function(task)
  assert(
    type(task) == 'function', string.format(
      'Expected `task` to be a function, got %s instead.', type(task)
    )
  )
  local success, result = pcall(task)
  if not success then
    if backbone.isDevelopment() then
      local file, line, message = string.split(':', result, 3)
      backbone.printf('<error>[Backbone]%s</end>', message)
      backbone.printf('%s (line %d)', file, line)
    else
      -- TODO: implement error handling in production mode.
      backbone.print 'Production mode error handling not implemented yet.'
    end
  end
end

---
---Queues the provided callback for execution in the next frame.
---Useful for tasks that does not require immediate execution.
---
---@param task backbone.task
---
backbone.queueTask = function(task)
  assert(
    type(task) == 'function', string.format(
      'Expected `task` to be a function, got %s instead.', type(task)
    )
  )
  array.append(tasks, task)
end

---
---Responsible for handling the execution of queued tasks.
---Ensures that the tasks are executed in a non-blocking manner.
---
taskFrame:SetScript(
  'OnUpdate', function()
    if tasks[1] ~= nil then
      local time_limit = 0.01667 -- 60 fps
      local time_started = GetTimePreciseSec()

      while tasks[1] ~= nil and (GetTimePreciseSec() - time_started < time_limit) do
        backbone.executeTask(table.remove(tasks, 1))
      end
    end
  end
)
