---@class __backbone
local context = select(2, ...)

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
---@field token backbone.token
---@field defaults backbone.storage-unit
---@field storage backbone.storage-unit
---
local manager = {}

---
---Create a new settings manager for the specified addon.
---
---@param token backbone.token
---@param settings table
---
manager.new = function(self, token, settings)
  local defaults = storageUnit:new(settings)
  local variables = backbone.useStorage(token)

  if variables:get '__settings' == nil then
    variables:set('__settings', {})
  end
  self.initialize(token, defaults, variables)
  return inherit(self, {
    token = token, defaults = defaults, storage = variables
  })
end

---
---Sync the default settings with the current settings stored in the addon storage.
---* Settings are synced only when the addon version is newer than the one present in the storage,
---or if the framework operates in development mode.
---
---@param token backbone.token
---@param defaults backbone.storage-unit
---@param variables backbone.storage-unit
---
manager.initialize = function(token, defaults, variables)
  local updateSettings = true
  local addonVersion = backbone.getAddonVersionNumber(token.name)
  if not backbone.isDevelopment() then
    local storedVersion = variables:get('__version')
    updateSettings = (storedVersion or -1) < addonVersion
  end

  if updateSettings then
    local syncSettings
    ---
    ---Synchronizes settings between a source table and a target table.
    ---
    ---@param source table
    ---@param target table
    ---
    syncSettings = function(source, target)
      -- Iterate over all keys and values in the source table.
      for sourceKey, sourceValue in pairs(source) do
        -- If the value in the source is a table, handle nested tables and lists separately.
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

    syncSettings(defaults.data, variables:get('__settings'))
    variables:set('__version', addonVersion)
  end
end

---
---
---
---@param key string
---@return unknown
---
manager.getValue = function(self, key)
  local value = self.storage:get('__settings/' .. tostring(key))
  if value == nil then
    throw('The key `%s` does not exist in the settings.', key)
  end
  return value
end

---
---
---
---@param list string
---@param key string|number
---@return unknown
---
manager.getValueFromList = function(self, list, key)
  ---@type backbone.list-setting
  local content = self.storage:get('__settings/' .. list)
  if type(content) ~= 'table' or not content.__list then
    throw('The list `%s` does not exist in the settings.', list)
  end
  return hashmap.get(content, tostring(key))
end

---
---
---
---@param key string
---@return unknown
---
manager.getDefaultValue = function(self, key)
  local value = self.defaults:get(key)
  if value == nil then
    throw('The key `%s` does not exist in the default settings.', key)
  end
  return value
end

---
---
---
---@param list string
---@param key string|number
---@return unknown
---
manager.getDefaultValueFromList = function(self, list, key)
  ---@type backbone.list-setting
  local content = self.defaults:get(list)
  if type(content) ~= 'table' or not content.__list then
    throw('The list `%s` does not exist in the default settings.', list)
  end
  return hashmap.get(content, tostring(key))
end

---
---
---
---@generic V
---@param key string
---@param value V
---@return V
---
manager.setValue = function(self, key, value)
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
---
---
---@generic V
---@param list string
---@param key string|number
---@param value V
---@return V
---
manager.setListValue = function(self, list, key, value)
  local defaultContent = self:getDefaultValue(list)
  if type(defaultContent) ~= 'table' or not defaultContent.__list then
    throw('The list `%s` does not exist in the default settings.', list)
  end
  if type(value) ~= defaultContent.__type then
    throw('The list "%s" expect values of type %s, got %s.',
      defaultContent.__type, type(value)
    )
  end
  local content = self.storage:get('__settings/' .. list)
  hashmap.set(content, key, value)
  backbone.triggerCustomEvent(context.token,
    'SETTING_CHANGED/' .. self.token.name, { list = list, key = key, value = value }
  )
  return value
end

---
---Convert an array of elements into a toggleable list structure.
---Each element in the array becomes a string key in the list, with a value of `true`.
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
    if key ~= '__list' then
      list[tostring(key)] = defaultValue
    end
  end)
  return list
end

---
---Retrieve the settings manager for the specified token.
---
---@param token backbone.token
---@param defaults table
---
backbone.useSettings = function(token, defaults)
  if hashmap.contains(registry, token) then
    return hashmap.get(registry, token) -- reuse the existing manager.
  else
    backbone.createCustomEvent(context.token, 'SETTING_CHANGED/' .. token.name)
    return hashmap.set(registry, token, manager:new(token, defaults))
  end
end
