--[[~ Updated: 2025/07/16 | Author(s): Gopher ]]
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
---A pseudo-switch statement function that returns the result of a case.
---
---@generic V
---
---@param value V
---@param cases table<'default'|array<V>|V, unknown|(fun(): unknown?)>
---@return unknown?
---
switch = function(value, cases)
  if value == nil then
    throw('Expected argument `value` to be non-nil.')
  end

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

  if case == nil then
    case = cases.default
  end

  if type(case) == 'function' then
    return case() -- return the result of the function.
  end

  return case -- return the value.
end
