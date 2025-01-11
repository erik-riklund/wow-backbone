---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/09 | Author(s): Gopher ]]
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

local tokens = ({} --[[@as table<string, backbone.token>]])

---
---Create an identifier for an addon based on its name.
---
---@param addonName string
---@return string
---
context.getTokenId = function(addonName)
  return string.lower(addonName)
end

---
---Create a token used to identify an addon within the Backbone ecosystem.
---
---@param addonName string
---@return backbone.token
---
backbone.createToken = function(addonName)
  local addonId = context.getTokenId(addonName)
  assert(
    not hashmap.contains(tokens, addonId), string.format(
      'A token with the name "%s" already exists.', addonName
    )
  )
  return hashmap.set(tokens, addonId,
    createProtectedProxy({ name = addonName })
  )
end

---
---Used internally to represent the framework itself.
--
context.token = backbone.createToken 'Backbone'
