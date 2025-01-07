---@class __backbone
local context = select(2, ...)

---@diagnostic disable: invisible

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

---@class backbone.addon
local __addon = context.__addon

local array = backbone.utils.array
local dictionary = backbone.utils.dictionary
local traverse = backbone.utils.table.traverse

--=============================================================================
-- STATE MANAGER:
--
-- This module manages saved variables for addons, ensuring consistent storage
-- and retrieval of account-wide and character-specific data. It organizes
-- variables into two scopes: account-wide (shared across characters) and
-- character-specific (unique to the current character).
--=============================================================================

---
---Responsible for initializing saved variables for addons.
---
array.insert(
  context.addon_initializers,
  ---@param addon backbone.addon
  function(addon)
    ---
    ---!
    ---
    ---@param scope string
    ---@return table
    ---
    local createStorage = function(scope)
      local variable = string.format(
        '%s%sVariables', addon:getName(), scope
      )
      _G[variable] = _G[variable] or {}
      return _G[variable]
    end

    addon.variables = {
      account = createStorage 'Account',
      character = createStorage 'Character'
    }
  end
)

---
---Break a variable path into its components.
---
---@param path string
---@return string[]
---
local parseVariablePath = function(path)
  return { string.split('/', path) }
end

---
---Retrieve the value of a saved variable from the specified scope.
---
---@param addon backbone.addon
---@param scope 'account'|'character'
---@param key string
---@return unknown
---
local getVariable = function(addon, scope, key)
  assert(
    type(addon.variables) == 'table', string.format(
      'Saved variables are not initialized for addon "%s".', addon:getName()
    )
  )
  return traverse(addon.variables[scope], parseVariablePath(key))
end

---
---Retrieve the value of a saved account variable.
---
---@param key string
---@return unknown
---
__addon.getAccountVariable = function(self, key)
  return getVariable(self, 'account', key)
end

---
---Retrieve the value of a saved character variable.
---
---@param key string
---@return unknown
---
__addon.getCharacterVariable = function(self, key)
  return getVariable(self, 'character', key)
end

---
---Set the value of a saved variable in the specified scope.
---
---@param addon backbone.addon
---@param scope 'account'|'character'
---@param key string
---@param value unknown
---
local setVariable = function(addon, scope, key, value)
  assert(
    type(addon.variables) == 'table', string.format(
      'Saved variables are not initialized for addon "%s".', addon:getName()
    )
  )
  local parents = parseVariablePath(key)
  local variable = table.remove(parents)

  traverse(addon.variables[scope], parents, 'build')[variable] = value
end

---
---Set the value of a saved account variable.
---
---@param key string
---@param value unknown
---
__addon.setAccountVariable = function(self, key, value)
  setVariable(self, 'account', key, value)
end

---
---Set the value of a saved character variable.
---
---@param key string
---@param value unknown
---
__addon.setCharacterVariable = function(self, key, value)
  setVariable(self, 'character', key, value)
end