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

---
---A table storing tokens, where each key is an identifier for
---an addon and each value is a `backbone.token` instance.
---
---@type table<string, backbone.token>
---
local tokens = {}

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
---Retrieve the token associated with an addon.
---
---@param addonName string
---@return backbone.token
---
context.getToken = function(addonName)
  local addonId = context.getTokenId(addonName)
  assert(
    hashmap.contains(tokens, addonId), string.format(
      'A token with the name "%s" does not exist.', addonName
    )
  )
  return hashmap.get(tokens, addonId)
end

---
---Validate the provided token by comparing it to the
---registered token for the specified addon.
---
---@param token backbone.token
---@return boolean
---
context.validateToken = function(token)
  return context.getToken(token.name) == token
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
