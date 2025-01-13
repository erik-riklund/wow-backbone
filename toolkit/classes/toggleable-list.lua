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

assert(toggleableList == nil,
  'Global variable conflict: `toggleableList` has already been defined.'
)

---
---
---
---@class backbone.toggleable-list
---@field content table<string, boolean>
---
_G.toggleableList = {}

---
---
---
---@private
---@param keys array<string>
---@return backbone.toggleable-list
---
toggleableList.new = function(self, keys)
  ---@diagnostic disable-next-line: missing-return
end

---
---
---@static
---@param elements array<string|number>
---@return table<string, boolean>
---
toggleableList.prepare = function(elements)
  ---@type table<string, boolean>
  local list = { __toggleable = true }
  array.iterate(elements,
    function(_, key)
      if key ~= '__toggleable' then
        list[tostring(key)] = true
      end
    end
  )
  return list
end
