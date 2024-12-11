--[[~ Updated: 2024/12/03 | Author(s): Gopher ]]

--Backbone - A World of Warcraft Addon Framework
--Copyright (C) 2024 Erik Riklund (Gopher)
--
--This program is free software: you can redistribute it and/or modify it under the terms
--of the GNU General Public License as published by the Free Software Foundation, either
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU General Public License <https://www.gnu.org/licenses/> for more details.

---@param target table
---@param steps table
---@param mode? 'exit'|'build'|'strict'
---
---@return unknown?
---
---Use this function to access or ensure the existence of deeply nested structures in a table.
---It navigates through the `target` table's nested structure based on a sequence of `steps`,
---allowing for flexible handling of missing paths. The behavior depends on the specified `mode`:
---
---* `exit` Stops traversal and returns `nil` if any step in the path does not exist.
---* `build` Automatically creates missing tables along the specified path.
---* `strict` Throws an error if a step in the path is not a table or does not exist.
---
---By default, the `exit` mode is used.
---
backbone.traverseTable = function (target, steps, mode)
  mode = mode or 'exit'

  if type (target) ~= 'table' then
    error('Expected a table for argument #1 (target).', 3)
  end
  if type (steps) ~= 'table' then
    error('Expected a table for argument #2 (steps).', 3)
  end
  if mode ~= 'exit' and mode ~= 'build' then
    error('Expected "exit" or "build" for argument #3 (mode).', 3)
  end

  local result = target
  for index, step in ipairs (steps) do
    if result[step] == nil  then
      if mode == 'exit' then return nil else result[step] = {} end
    end

    if type (result[step]) ~= 'table' and index < #steps then
      if mode == 'strict' then
        backbone.throw ('The step "%s" is not a table.', step)
      end

      return nil
    end
    
    result = result[step]
  end

  return result
end
