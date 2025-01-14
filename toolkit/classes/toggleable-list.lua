--[[~ Updated: 2025/01/14 | Author(s): Gopher ]]
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
---Represents a list of toggleable elements.
---
---@class backbone.toggleable-list
---@field content backbone.toggleable-list.content
---
_G.toggleableList = {}

---
---Create a new toggleable list object.
---
---@private
---@param content backbone.toggleable-list.content
---@return backbone.toggleable-list
---
toggleableList.new = function(self, content)
  return inherit(self, { content = content })
end

---
---Determine if the specified key is enabled (`true`).
---
---@param key string|number
---@return boolean
---
toggleableList.isEnabled = function(self, key)
  return self.content[tostring(key)] == true
end

---
---Set the state of the specified key.
---
---@param key string|number
---@param state 'enabled'|'disabled'
---
toggleableList.setState = function(self, key, state)
  if state ~= 'enabled' and state ~= 'disabled' then
    throw('Expected argument `state` to be either `enabled` or `disabled`.')
  end
  hashmap.set(self.content, tostring(key), state == 'enabled')
end

---
---Convert an array of elements into a toggleable list structure.
---
---@param elements array<string|number>
---@return backbone.toggleable-list.content
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
