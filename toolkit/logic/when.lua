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

assert(when == nil,
  'Global variable conflict: `when` has already been defined.'
)

---
---Implements a pseudo-ternary operator that may be used for falsy conditions
---where the built-in short circuit evaluation fails.
---
---@param condition boolean
---@param onTrue unknown
---@param onFalse unknown
---@return unknown?
---
_G.when = function(condition, onTrue, onFalse)
  local result = onFalse
  if condition == true then result = onTrue end
  
  return result
end
