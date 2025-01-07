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
---A handy set of utility functions for working with arrays. Includes improved versions
---of standard table functions, with extra checks to keep things smooth and error-free.
---
---@class backbone.array
---
_G.array = {}

---
---Append an element to the end of the array.
---
---@generic V
---@param target V[]
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
---@param target V[]
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
