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
---
---
---@generic K, V
---@param target table<K, V>
---@param key K
---@param value V
---@return V
---
hashmap.set = function(target, key, value)
  assert(value ~= nil,
    'Expected argument `value` to be non-nil.'
  )
  target[key] = value
  return value
end
