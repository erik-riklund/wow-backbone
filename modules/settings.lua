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

local dictionary = backbone.utils.dictionary
local traverse = backbone.utils.table.traverse

--=============================================================================
-- SETTINGS MANAGER:
--
-- <add description of the module
--=============================================================================

local createDefaultSettingsTable
local settings_prefix = '$settings'

---
---!
---
---@param target table
---@param settings table
---
createDefaultSettingsTable = function(target, settings)
  for key, value in pairs(settings) do
    if type(value) == 'table' then
      createDefaultSettingsTable(
        dictionary.set(target, key, {}), value
      )
    else
      dictionary.set(target, key, value)
    end
  end
end

---
---!
---
---@param addon backbone.addon
---
local syncSettingsTable = function(addon)
  local syncSettings

  ---
  ---!
  ---
  ---@param target table
  ---@param source table
  ---
  syncSettings = function(target, source)

  end

  if not addon:getAccountVariable(settings_prefix) then
    addon:setAccountVariable(settings_prefix, {})
  end
  syncSettings(
    addon:getAccountVariable(settings_prefix), addon.settings
  )
end

---
---?
---
---@param settings table
---
__addon.setDefaultSettings = function(self, settings)
  assert(
    self.settings == nil, string.format(
      'Default settings have already been set for addon "%s".', self:getName()
    )
  )

  createDefaultSettingsTable(
    dictionary.set(self, 'settings', {}), settings
  )

  self:onReady(
    function()
      if backbone.getEnvironment() == 'development' then
        syncSettingsTable(self) -- in development mode, settings are always synced on startup.
      else
        -- TODO: implement version checks for updating the settings table.
      end
    end
  )
end

---
---!
---
---@param key string
---@return string
---
local getSettingPath = function(key)
  return string.format('%s/%s', settings_prefix, key)
end

---
---!
---
---@param key string
---@return unknown
---
__addon.getDefaultSetting = function(self, key)
  return traverse(self.settings, { string.split('/', key) })
end

---
---?
---
---@param key string
---@return unknown
---
__addon.getSimpleSetting = function(self, key)
  local value = self:getAccountVariable(getSettingPath(key))
  if value ~= nil then
    return value -- if the value is found, return it.
  end

  local default_value = self:getDefaultSetting(key)
  assert(
    default_value ~= nil, string.format(
      'The requested setting "%s" does not exist (%s).', key, self:getName()
    )
  )
  return default_value
end

---
---?
---
---@generic V
---@param key string
---@param value V
---@return V
---
__addon.setSimpleSetting = function(self, key, value)
  ---@diagnostic disable-next-line: missing-return
  print 'addon.setSetting not implemented'
end

---
---Provides a list of keys that can be toggled on and off.
---
---@class backbone.toggleable-list
---@field private source table<string, boolean>
---
local toggleableList =
{
  ---
  ---Determine if the specified key is enabled.
  ---
  ---@param self backbone.toggleable-list
  ---@param key string|number
  ---@return boolean
  ---
  isEnabled = function(self, key)
    return (self.source[tostring(key)] == true)
  end,

  ---
  ---Toggle the value of the specified key.
  ---
  ---@param self backbone.toggleable-list
  ---@param key string|number
  ---
  toggle = function(self, key)
    key = tostring(key)
    self.source[key] = not self.source[key]
  end,

  ---
  ---Set the value of the specified key.
  ---
  ---@param self backbone.toggleable-list
  ---@param key string|number
  ---@param value boolean
  ---
  set = function(self, key, value)
    self.source[tostring(key)] = value
  end
}

---
---?
---
---@param key string
---@return backbone.toggleable-list
---
__addon.getToggleableListSetting = function(self, key)
  local source = self:getSimpleSetting(key)
  assert(
    type(source) == 'table', string.format(
      'The requested setting "%s" is not a toggleable list (%s).', key, self:getName()
    )
  )
  local instance = setmetatable({ source = source }, { __index = toggleableList })
  return instance --[[@as backbone.toggleable-list]]
end

---
---Convert a list of values into a toggleable list structure.
---
---@param content string[]|number[]
---@return table<string, boolean>
---
backbone.createToggleableList = function(content)
  ---@type table<string, boolean>
  local list = {}
  for _, value in ipairs(content) do
    list[tostring(value)] = true
  end
  return list
end
