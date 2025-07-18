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

assert(capitalize == nil,
  'Global variable conflict: `capitalize` has already been defined.'
)

---
---Capitalizes the first letter of a given string.
---
---@param target string
---@return string
---
_G.capitalize = function(target)
  return string.sub(target, 1, 1):upper() .. string.sub(target, 2)
end
