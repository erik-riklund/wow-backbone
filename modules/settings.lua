--[[~ Updated: 2025/01/12 | Author(s): Gopher ]]
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

---
---
---
---@type table<backbone.token, backbone.settings-manager>
---
local registry = {}

---
---
---
---@class backbone.settings-manager
---
local manager = {}

---
---
---
---@param token backbone.token
---@param defaults table
---
manager.new = function(self, token, defaults)

end

---
---
---
---@param elements array<string|number>
---@return table<string, boolean>
---
backbone.createToggleableList = function(elements)
  local list = ({} --[[@as table<string, boolean>]])
  array.iterate(elements,
    function(_, key) list[tostring(key)] = true end
  )
  return list
end

---
---
---
---@param token backbone.token
---@param defaults table
---
backbone.useSettings = function(token, defaults)
  assert(
    not hashmap.contains(registry, token), string.format(
      'A settings manager has already been registered for the provided token (%s).', token.name
    )
  )
  return hashmap.set(registry, token, manager:new(token, defaults))
end
