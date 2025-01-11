--[[~ Updated: 2025/01/11 | Author(s): Gopher ]]
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

assert(storageUnit == nil,
  'Global variable conflict: `storageUnit` has already been defined.'
)

---
---
---
---@class backbone.storage-unit
---@field data table
---
_G.storageUnit = {}

---
---
---
---@private
---@param source table
---@return backbone.storage-unit
---
storageUnit.new = function(self, source)
  assert(
    type(source) == 'table', string.format(
      'Expected `source` to be a table, got %s instead.', type(source)
    )
  )
  return inherit(self, { data = source })
end

---
---
---
storageUnit.get = function(self, key) end

---
---
---
storageUnit.set = function(self, key, value) end
