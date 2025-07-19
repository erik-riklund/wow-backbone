--[[~ Updated: 2025/07/19 | Author(s): Gopher ]]
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

assert(traverseTable == nil,
  'Global variable conflict: `traverseTable` has already been defined.'
)

---
---Traverses a table through a series of steps (keys).
---It can operate in different modes:
---- `exit` returns `nil` if a step is missing
---- `build` creates new tables for missing steps
---- `error` throws an error for missing or invalid steps
---
---@param target table
---@param steps array<backbone.hashmap-key-type>
---@param mode? 'exit'|'build'|'error'
---
---@return unknown
---
_G.traverseTable = function(target, steps, mode)
  if mode ~= nil and mode ~= 'exit' and mode ~= 'build' and mode ~= 'error' then
    throw('Expected `mode` to be one of "exit", "build", or "error"; got "%s".', mode)
  end

  ---@type unknown
  local value = target
  local step_count = #steps

  for index, step in ipairs(steps) do
    local current_value = value[step]
    local current_value_type = type(current_value)
    local is_last_step = (index == step_count)

    if current_value_type == 'nil' then
      if mode == 'error' then
        error(string.format(
          'The step "%s" does not exist.', tostring(step)
        ))
      elseif mode == 'build' then
        current_value = hashmap.set(value, step, {})
      else
        return nil -- the step does not exist, exit early.
      end
    elseif not is_last_step and current_value_type ~= 'table' then
      if mode == 'error' then
        error(string.format(
          'The step "%s" is not a table.', tostring(step)
        ))
      else
        return nil -- the step does not exist, exit early.
      end
    end

    value = current_value --[[@as unknown]]
  end

  return value
end
