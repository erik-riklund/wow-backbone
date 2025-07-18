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

assert(hashmap == nil,
  'Global variable conflict: `hashmap` has already been defined.'
)

---
---A utility library providing common hash map (table) manipulation functions.
---
---@class backbone.hashmap
---
_G.hashmap = {}

---
---Checks if the target hash map contains a specific key.
---
---@generic K
---
---@param target table<K, unknown>
---@param key K
---@return boolean
---
hashmap.contains = function(target, key)
  return (target[key] ~= nil)
end

---
---Removes a key-value pair from the target hash map and returns the removed value.
---
---@generic K, V
---
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
---Retrieves the value associated with a specific key from the target hash map.
---
---@generic K, V
---
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
---Iterates over the key-value pairs of the target hash map, applying a callback function to each.
---If the callback returns a non-nil value, that value replaces the original value for the key.
---
---@generic K, V
---
---@param target table<K, V>
---@param callback fun(key: K, value: V): V?
---
hashmap.iterate = function(target, callback)
  for key, value in pairs(target) do
    local result = callback(key, value)

    if result ~= nil then
      target[key] = result
    end
  end
end

---
---Returns an array containing all the keys present in the target hash map.
---
---@generic K
---
---@param target table<K, unknown>
---@return array<K>
---
hashmap.keys = function(target)
  local keys = {}
  
  for key in pairs(target) do
    array.append(keys, key)
  end

  return keys
end

---
---Sets a key-value pair in the target hash map.
---
---@generic K, V
---
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
