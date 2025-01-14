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
---Represents a storage unit for managing and accessing hierarchical data.
---
---@class backbone.storage-unit
---@field data table
---
_G.storageUnit = {}

---
---Create a new storage unit that use the provided data source.
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
---Retrieve the value associated with the provided key.
---
---@param key string
---@return unknown
---
storageUnit.get = function(self, key)
  return traverseTable(self.data, { string.split('/', tostring(key)) })
end

---
---Set the value associated with the provided key. If the key does not exist,
---it will be created. The provided value is returned for chainability.
---
---@generic V
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
