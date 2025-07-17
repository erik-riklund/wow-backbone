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

assert(when == nil,
  'Global variable conflict: `when` has already been defined.'
)

---
---A conditional function that returns one of two values (or the result of one of two functions)
---based on a boolean condition, similar to a ternary operator.
---
---@param condition boolean
---@param onTrue unknown
---@param onFalse unknown
---
---@return unknown?
---
_G.when = function(condition, onTrue, onFalse)
  local result = onFalse

  if condition == true then
    result = onTrue
  end

  if type(result) == 'function' then
    return result() -- return the result of the function.
  end

  return result -- return the value.
end
