---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/07/19 | Author(s): Gopher ]]
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
---A collection of registered tokens, indexed by their lowercase addon name.
---
---@type table<string, backbone.token>
---
local tokens = {}

---
---Retrieves a previously created token by its addon name.
---
---@param addon_name string
---@return backbone.token
---
context.getToken = function(addon_name)
  local addon_id = context.getTokenId(addon_name)

  if not hashmap.contains(tokens, addon_id) then
    throw('A token with the name "%s" does not exist.', addon_name)
  end

  return hashmap.get(tokens, addon_id)
end

---
---Generates a standardized token ID from an addon name.
---
---@param addon_name string
---@return string id
---
context.getTokenId = function(addon_name)
  return string.lower(addon_name)
end

---
---Validates if a given token object is legitimate and
---matches the stored token for its addon name.
---
---@param token backbone.token
---@return boolean isValid
---
context.validateToken = function(token)
  return (context.getToken(token.name) == token)
end

---
---Creates and registers a new token for a given addon name.
---
---@param addon_name string
---@return backbone.token
---
backbone.createToken = function(addon_name)
  local addon_id = context.getTokenId(addon_name)

  if hashmap.contains(tokens, addon_id) then
    throw('A token with the name "%s" already exists.', addon_name)
  end

  return hashmap.set(tokens,
    addon_id, createProtectedProxy({ name = addon_name })
  )
end

--The token used internally by the framework to create and trigger custom events.
context.token = backbone.createToken('Backbone')
