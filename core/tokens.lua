---@class __backbone
local context = select(2, ...)

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

---
---@type table<string, backbone.token>
---
local tokens = {}

---
---@param addonName string
---@return string id
---
context.getTokenId = function(addonName) return string.lower(addonName) end

---
---@param addonName string
---@return backbone.token
---
context.getToken = function(addonName)
  local addonId = context.getTokenId(addonName)
  if not hashmap.contains(tokens, addonId) then
    throw('A token with the name "%s" does not exist.', addonName)
  end
  return hashmap.get(tokens, addonId)
end

---
---@param token backbone.token
---@return boolean isValid
---
context.validateToken = function(token)
  return context.getToken(token.name) == token
end

---
---@param addonName string
---@return backbone.token
---
backbone.createToken = function(addonName)
  local addonId = context.getTokenId(addonName)
  if hashmap.contains(tokens, addonId) then
    throw('A token with the name "%s" already exists.', addonName)
  end
  return hashmap.set(tokens,
    addonId, createProtectedProxy({ name = addonName })
  )
end

--The token used by the framework to create and trigger custom events.
context.token = backbone.createToken 'Backbone'
