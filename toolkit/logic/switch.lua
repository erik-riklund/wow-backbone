--[[~ Updated: 2025/01/08 | Author(s): Gopher ]]
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

assert(switch == nil,
  'Global variable conflict: `switch` has already been defined.'
)

---
---A pseudo-switch statement using a table of cases and their associated actions.
---Each case can define a single value or a set of values to match against. The action
---for each case must be a function that returns the result, if any.
---
---@generic V
---@param value V
---@param cases table<'default'|array<V>|V, fun(): unknown?>
---@return unknown?
---
switch = function(value, cases)
  assert(value ~= nil, 
    'Expected argument `value` to be non-nil.'
  )
  local case = cases[value]

  if case == nil then
    for key, content in pairs(cases) do
      if type(key) == 'table' then
        for _, target in ipairs(key) do
          if target == value then
            case = content
            break -- the value was caught by a multi-case pattern.
          end
        end
      end
    end
  end

  if case == nil then case = cases['default'] end
  return (type(case) == 'function' and case()) or nil
end
