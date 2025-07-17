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

assert(storageUnit == nil,
  'Global variable conflict: `storageUnit` has already been defined.'
)

---
---Represents a unit for storing and managing data,
---allowing access and modification via string keys.
---
---@class backbone.storage-unit
---@field data table
---
_G.storageUnit = {}

---
---Creates a new storage unit instance, initialized with a source table.
---
---@private
---@param source table
---@return backbone.storage-unit
---
storageUnit.new = function(self, source)
  if type(source) ~= 'table' then
    throw('Expected `source` to be a table, got %s.', type(source))
  end

  return inherit(self, { data = source })
end

---
---Retrieves a value from the storage unit using a key,
---which can represent a path within the data table.
---
---@param key string
---@return unknown
---
storageUnit.get = function(self, key)
  return traverseTable(self.data, { string.split('/', tostring(key)) })
end

---
---Sets a value within the storage unit using a key,
---which can represent a path within the data table.
---
---@generic V
---
---@param key string
---@param value V
---@return V
---
storageUnit.set = function(self, key, value)
  local keys = { string.split('/', tostring(key)) }
  local variable = array.pop(keys)

  ---@type table
  local target = traverseTable(self.data, keys, 'build')
  target[variable] = value

  return value
end
