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

assert(inherit == nil,
  'Global variable conflict: `inherit` has already been defined.'
)

---
---Establishes an inheritance relationship between a child table and a parent table.
---The child table will inherit methods and properties from the parent table.
---
---@generic P:table
---
---@param parent P
---@param child table
---@return P
---
_G.inherit = function(parent, child)
  return setmetatable(child, { __index = parent })
end
