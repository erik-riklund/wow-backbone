---@class Backbone
local context = select(2, ...)

--[[~ Updated: 2024/12/08 | Author(s): Gopher ]]

--Backbone - A World of Warcraft addon framework
--Copyright (C) 2024 Erik Riklund (Gopher)
--
--This program is free software: you can redistribute it and/or modify it under the terms
--of the GNU General Public License as published by the Free Software Foundation, either
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU General Public License <https://www.gnu.org/licenses/> for more details.

local storage = new 'Dictionary'

---@param plugin Backbone.Plugin
---@param scope 'account'|'character'
---@param key string
---@return unknown?
---
local getVariable = function (plugin, scope, key)
  local pluginData = storage:getEntry (plugin) --[[@as table?]]

  if not pluginData then
    backbone.throw ('The plugin "%s" is not fully initialized. '
      .. 'Use an `onReady` wrapper to solve the problem.', plugin:getName()
    )
  end

  ---@cast pluginData table
  return backbone.traverseTable (
    pluginData[scope], backbone.splitString (key, '/'): toArray()
  )
end

---@param plugin Backbone.Plugin
---@param scope 'account'|'character'
---@param key string
---@param value unknown
---
local setVariable = function (plugin, scope, key, value)
  local pluginData = storage:getEntry (plugin) --[[@as table?]]

  if not pluginData then
    backbone.throw ('The plugin "%s" is not fully initialized. '
      .. 'Use an `onReady` wrapper to solve the problem.', plugin:getName()
)
  end

  ---@cast pluginData table
  local parents = backbone.splitString (key, '/')
  local variable = parents:removeElement() --[[@as string]]

  backbone.traverseTable (pluginData[scope], parents, 'build')[variable] = value
end

-- STORAGE INITIALIZATION --

context.plugin:registerChannelListener (
  'PLUGIN_LOADED', {
    callback = function (plugin)
      ---@cast plugin Backbone.Plugin
      local pluginData = {}

      for _, scope in ipairs {'Account', 'Character'} do
        local variableName = string.format (
          '%s%sVariables', plugin:getName(), scope
        )

        _G[variableName] = _G[variableName] or {}
        pluginData[string.lower (scope)] = _G[variableName]
      end

      storage:setEntry (plugin, pluginData)
    end
  }
)

-- PLUGIN API --

---@class Backbone.Plugin
local storageAPI = context.pluginAPI

---@param key string
---@return unknown?
---Returns the value associated with the specified key.
---
storageAPI.getAccountVariable = function (self, key)
  return getVariable (self, 'account', key)
end

---@param key string
---@param value unknown
---Sets the value associated with the specified key.
---
storageAPI.setAccountVariable = function (self, key, value)
  setVariable (self, 'account', key, value)
end

---@param key string
---@return unknown?
---Returns the value associated with the specified key.
---
storageAPI.getCharacterVariable = function (self, key)
  return getVariable (self, 'character', key)
end

---@param key string
---@param value unknown
---Sets the value associated with the specified key.
---
storageAPI.setCharacterVariable = function (self, key, value)
  setVariable (self, 'character', key, value)
end
