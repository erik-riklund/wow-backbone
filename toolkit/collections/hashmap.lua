--[[~ Updated: 2025/01/07 | Author(s): Gopher ]]
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

assert(hashmap == nil,
  'Global variable conflict: `hashmap` has already been defined.'
)

---
---Provides a set of functions for working with hashmaps.
---Built-in access checks help avoid errors that may be hard to debug.
---
---@class backbone.hashmap
---
_G.hashmap = {}

---
---Determines whether the target table contains the specified key.
---
---@generic K
---@param target table<K, unknown>
---@param key K
---@return boolean
---
hashmap.contains = function(target, key)
  return target[key] ~= nil
end

---
---Remove the value associated with the specified key and return it.
---
---@generic K, V
---@param target table<K, V>
---@param key K
---@return V
---
hashmap.drop = function(target, key)
  if target[key] == nil then
    throw('The key `%s` does not exist in the target table.', key)
  end
  local value = target[key]
  target[key] = nil
  return value
end

---
---Apply a function to each key/value pair of the table.
---The function can return a new value to replace the old value.
---
---@generic K, V
---@param target table<K, V>
---@param callback fun(key: K, value: V): V?
---
hashmap.iterate = function(target, callback)
  for key, value in pairs(target) do
    local result = callback(key, value)
    if result ~= nil then target[key] = result end
  end
end

---
---Retrieve the value associated with the specified key.
---
---@generic K, V
---@param target table<K, V>
---@param key K
---@return V
---
hashmap.get = function(target, key)
  if target[key] == nil then
    throw('The key `%s` does not exist in the target table.', key)
  end
  return target[key]
end

---
---Set the value associated with the specified key.
---
---@generic K, V
---@param target table<K, V>
---@param key K
---@param value V
---@return V
---
hashmap.set = function(target, key, value)
  if value == nil then
    throw('Expected argument `value` to be non-nil.')
  end
  target[key] = value
  return value
end
