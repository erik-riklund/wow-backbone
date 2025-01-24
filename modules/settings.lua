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
---@type table<backbone.token, backbone.settings-manager>
---
local registry = {}

---
---@class backbone.settings-manager
---
---@field token backbone.token
---@field scope backbone.storage-scope
---@field defaults backbone.storage-unit
---@field storage backbone.storage-unit
---
local settingsManager = {}

---
---@param token backbone.token
---@param scope backbone.storage-scope
---@param settings table
---
settingsManager.new = function(self, token, scope, settings)
  local defaults = storageUnit:new(settings)
  local manager = inherit(self, { token = token, scope = scope, defaults = defaults })
  backbone.onAddonLoaded(token.name, function() manager:initialize() end)
  return manager
end

---
---Synchronize the default settings with the stored settings.
---
settingsManager.initialize = function(self)
  self.storage = backbone.useStorage(self.token, self.scope)
  if self.storage:get '__settings' == nil then self.storage:set('__settings', {}) end

  local updateSettings = true
  local addonVersion = backbone.getAddonVersionNumber(self.token.name)

  if not backbone.isDevelopment() then
    local storedVersion = self.storage:get '__version' --[[@as number]]
    updateSettings = (storedVersion or -1) < addonVersion
  end

  if updateSettings then
    local syncSettings
    ---
    ---@param source table
    ---@param target table
    ---
    syncSettings = function(source, target)
      -- Iterate over all keys and values in the source table.
      for sourceKey, sourceValue in pairs(source) do
        -- Handle nested tables and lists.
        if type(sourceValue) == 'table' then
          -- Ensure the target has a table for this key.
          if target[sourceKey] == nil then
            target[sourceKey] = {}
          end

          if sourceValue.__list then
            -- Synchronize the content of the list.
            for listKey, listValue in pairs(sourceValue) do
              if target[sourceKey][listKey] == nil then
                target[sourceKey][listKey] = listValue
              end
            end
          else
            -- Recursively synchronize nested tables.
            syncSettings(sourceValue, target[sourceKey])
          end
        else
          -- If the value is not a table, add it to the target only if it's missing.
          if target[sourceKey] == nil then
            target[sourceKey] = sourceValue
          end
        end
      end

      -- Remove keys that don't exist in the source, if the target is not a list.
      if not target.__list then
        for targetKey in pairs(target) do
          if source[targetKey] == nil then target[targetKey] = nil end
        end
      end
    end

    syncSettings(self.defaults.data, self.storage:get '__settings')
    self.storage:set('__version', addonVersion)
  end
end

---
---@param scope backbone.storage-scope
---
settingsManager.setScope = function(self, scope)
  if scope ~= 'account' and scope ~= 'realm' and scope ~= 'character' then
    throw('Invalid scope "%s", must be "account", "realm" or "character".', scope)
  end
  self.scope = scope
  self:initialize()
end

---
---@param key string
---@return unknown
---
settingsManager.getValue = function(self, key)
  local value = self.storage:get('__settings/' .. tostring(key))
  if value == nil then
    throw('The key `%s` does not exist in the settings.', key)
  end
  return value
end

---
---@param list string
---@param key string|number
---@return unknown
---
settingsManager.getValueFromList = function(self, list, key)
  ---@type backbone.list-setting
  local content = self.storage:get('__settings/' .. list)
  if type(content) ~= 'table' or not content.__list then
    throw('The list `%s` does not exist in the settings.', list)
  end
  return content[tostring(key)]
end

---
---@param key string
---@return unknown
---
settingsManager.getDefaultValue = function(self, key)
  local value = self.defaults:get(key)
  if value == nil then
    throw('The key `%s` does not exist in the default settings.', key)
  end
  return value
end

---
---@param list string
---@param key string|number
---@return unknown
---
settingsManager.getDefaultValueFromList = function(self, list, key)
  ---@type backbone.list-setting
  local content = self.defaults:get(list)
  if type(content) ~= 'table' or not content.__list then
    throw('The list `%s` does not exist in the default settings.', list)
  end
  return content[tostring(key)]
end

---
---@generic V
---
---@param key string
---@param value V
---@return V
---
settingsManager.setValue = function(self, key, value)
  local currentValue = self:getValue(key)
  local defaultValue = self:getDefaultValue(key)
  if type(currentValue) ~= type(defaultValue) then
    throw('The setting "%s" must be of type %s, got %s.',
      key, type(defaultValue), type(currentValue)
    )
  end
  self.storage:set('__settings/' .. key, value)
  backbone.triggerCustomEvent(context.token,
    'SETTING_CHANGED/' .. self.token.name, { key = key, value = value }
  )
  return value
end

---
---@generic V
---
---@param list string
---@param key string|number
---@param value V
---@return V
---
settingsManager.setListValue = function(self, list, key, value)
  local defaultContent = self:getDefaultValue(list)
  if type(defaultContent) ~= 'table' or not defaultContent.__list then
    throw('The list `%s` does not exist in the default settings.', list)
  end
  if type(value) ~= defaultContent.__type then
    throw('The list "%s" expect values of type %s, got %s.', defaultContent.__type, type(value))
  end
  if key == '__list' or key == '__type' then
    throw('The key `%s` cannot be used as a list key.', key)
  end

  local content = self.storage:get('__settings/' .. list)
  hashmap.set(content, tostring(key), value)
  backbone.triggerCustomEvent(context.token,
    'SETTING_CHANGED/' .. self.token.name, { list = list, key = key, value = value }
  )
  return value
end

---
---@param valueType 'boolean'|'string'|'number'
---@param elements array<string|number>
---@return backbone.list-setting
---
backbone.createListSetting = function(valueType, elements)
  if not array.contains({ 'boolean', 'string', 'number' }, valueType) then
    throw('Invalid value type `%s`, must be `boolean`, `string` or `number`.', valueType)
  end
  local defaultValue = switch(
    valueType, { boolean = true, number = 0, string = '' }
  )
  ---@type backbone.list-setting
  local list = { __list = true, __type = valueType }
  array.iterate(elements, function(_, key)
    if key ~= '__list' and key ~= '__type' then
      list[tostring(key)] = defaultValue
    end
  end)
  return list
end

---
---@param token backbone.token
---@param defaults table
---@param scope? backbone.storage-scope
---
backbone.useSettings = function(token, defaults, scope)
  if not context.validateToken(token) then
    throw 'The provided token is not registered.'
  end

  if hashmap.contains(registry, token) then
    return hashmap.get(registry, token) -- reuse the existing manager.
  end

  backbone.createCustomEvent(context.token, 'SETTING_CHANGED/' .. token.name)
  return hashmap.set(registry, token,
    settingsManager:new(token, scope or 'account', defaults)
  )
end
