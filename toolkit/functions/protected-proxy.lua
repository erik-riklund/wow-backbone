--[[~ Updated: 2025/01/21 | Author(s): Gopher ]]
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

assert(createProtectedProxy == nil,
  'Global variable conflict: `createProtectedProxy` has already been defined.'
)

local blocker = function()
  error('Blocked attempt to modify a protected table.', 2)
end

---
---@generic T:table
---
---@param target T
---@param key unknown
---@return unknown?
---
local retriever = function(target, key)
  local value = target[key]
  return (type(value) == 'table' and createProtectedProxy(value)) or value
end

---
---@generic T:table
---
---@param target T
---@return T
---
_G.createProtectedProxy = function(target)
  return setmetatable({},
    {
      __newindex = blocker,
      __index = function(_, key)
        return retriever(target, key)
      end
    }
  )
end
