--[[~ Updated: 2025/01/12 | Author(s): Gopher ]]
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
---Traverse a nested table structure using a series of keys (steps).
---Supports different modes of behavior when encountering missing or invalid keys:
--- - `exit` (default): Stops and returns `nil` if a step does not exist, or if a non-table step is encountered.
--- - `build`: Creates intermediate tables for missing steps.
--- - `error`: Throws an error if a step is missing or invalid.
---
---@param target table
---@param steps array<backbone.hashmap-key-type>
---@param mode? 'exit'|'build'|'error'
---@return unknown
---
_G.traverseTable = function(target, steps, mode)
  mode = mode or 'exit'
  assert(
    array.contains({ 'exit', 'build', 'error' }, mode), string.format(
      'Expected `mode` to be one of "exit", "build", or "error", got "%s" instead.', mode
    )
  )
  ---@type unknown
  local value = target
  local stepCount = #steps

  for index, step in ipairs(steps) do
    assert(
      step ~= nil, 'Expected argument `step` to be non-nil.'
    )
    local currentValue = value[step]
    local currentValueType = type(currentValue)
    local isLastStep = (index == stepCount)

    if currentValueType == 'nil' then
      if mode == 'error' then
        error(string.format('The step "%s" does not exist.', tostring(step)))
      elseif mode == 'build' then
        currentValue = hashmap.set(value, step, {})
      else
        return nil -- the step does not exist, exit early.
      end
    elseif not isLastStep and currentValueType ~= 'table' then
      if mode == 'error' then
        error(string.format('The step "%s" is not a table.', tostring(step)))
      else
        return nil -- the step does not exist, exit early.
      end
    end

    value = currentValue --[[@as unknown]]
  end
  return value
end
