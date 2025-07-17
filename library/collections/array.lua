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

assert(array == nil,
  'Global variable conflict: `array` has already been defined.'
)

---
---A utility library providing common array manipulation functions.
---
---@class backbone.array
---
_G.array = {}

---
---Appends an element to the end of the target array.
---
---@generic V
---
---@param target array<V>
---@param element V
---@return V
---
array.append = function(target, element)
  if element == nil then
    throw('Expected argument `element` to be non-nil.')
  end

  table.insert(target, element)
  return element
end

---
---Clears all elements from the target array.
---
---@generic V
---
---@param target array<V>
---@return array<V>
---
array.clear = function(target) return wipe(target) end

---
---Checks if the target array contains a specific search value.
---
---@generic V
---
---@param target array<V>
---@param searchValue V
---@return boolean
---
array.contains = function(target, searchValue)
  if searchValue == nil then
    throw('Expected argument `searchValue` to be non-nil.')
  end

  if #target > 0 then
    for _, value in ipairs(target) do
      if value == searchValue then return true end
    end
  end

  return false
end

---
---Iterates over the elements of the target array, applying a callback function to each.
---If the callback returns a non-nil value, that value replaces the original element.
---
---@generic V
---
---@param target array<V>
---@param callback fun(index: number, value: V): V?
---
array.iterate = function(target, callback)
  for index, value in ipairs(target) do
    local result = callback(index, value)

    if result ~= nil then
      target[index] = result
    end
  end
end

---
---Removes and returns the last element from the target array.
---
---@generic V
---
---@param target array<V>
---@return V
---
array.pop = function(target)
  return array.remove(target, #target)
end

---
---Removes and returns the element at the specified index from the target array.
---
---@generic V
---
---@param target array<V>
---@param index number
---@return V
---
array.remove = function(target, index)
  if target[index] == nil then
    throw('Expected argument `index` to be within the bounds of the array.')
  end
  
  return table.remove(target, index)
end
