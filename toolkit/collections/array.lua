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

assert(array == nil,
  'Global variable conflict: `array` has already been defined.'
)

---
---Contains a set of robust utility functions for working with arrays.
---Built-in access checks help avoid errors that may be hard to debug.
---
---@class backbone.array
---
_G.array = {}

---
---Append an element to the end of the array.
---
---@generic V
---@param target array<V>
---@param element V
---@return V
---
array.append = function(target, element)
  assert(element ~= nil,
    'Expected argument `element` to be non-nil.'
  )
  table.insert(target, element)
  return element
end

---
---
---
---@generic V
---@param target array<V>
---@return array<V>
---
array.clear = function(target) return wipe(target) end

---
---Determine if the array contains the specified value.
---
---@generic V
---@param target array<V>
---@param searchValue V
---@return boolean
---
array.contains = function(target, searchValue)
  assert(searchValue ~= nil,
    'Expected argument `searchValue` to be non-nil.'
  )
  if #target > 0 then
    for _, value in ipairs(target) do
      if value == searchValue then return true end
    end
  end
  return false
end

---
---Apply a callback function to each element of the array.
---The function can return a new value to replace the old value.
---
---@generic V
---@param target array<V>
---@param callback fun(index: number, value: V): V?
---
array.iterate = function(target, callback)
  for index, value in ipairs(target) do
    local result = callback(index, value)
    if result ~= nil then target[index] = result end
  end
end

---
---Remove and return the last element from the array.
---
---@generic V
---@param target array<V>
---@return V
---
array.pop = function(target)
  return array.remove(target, #target)
end

---
---Remove an element from the array. The removed value is returned.
---
---@generic V
---@param target array<V>
---@param index number
---@return V
---
array.remove = function(target, index)
  assert(target[index] ~= nil,
    'Expected argument `index` to be within the bounds of the array.'
  )
  return table.remove(target, index)
end
