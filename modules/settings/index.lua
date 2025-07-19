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
---A registry of all active settings managers, indexed by their owner tokens.
---
---@type table<backbone.token, backbone.settings-manager>
---
local registry = {}

---
---Manages persistent settings for a specific addon,
---handling defaults, storage, and migrations.
---
---@class backbone.settings-manager
---
---@field token backbone.token
---@field scope backbone.storage-scope
---@field defaults backbone.storage-unit
---@field storage backbone.storage-unit
---
local settings_manager = {}

---
---Creates a new settings manager.
---
---@param token backbone.token
---@param scope backbone.storage-scope
---@param settings table
---
settings_manager.new = function(self, token, scope, settings)
  local defaults = storageUnit:new(settings)
  local manager = inherit(self, { token = token, scope = scope, defaults = defaults })
  backbone.onAddonLoaded(token.name, function() manager:initialize() end)
  return manager
end

---
---Initializes or re-initializes the settings manager,
---loading data and performing migrations.
---
settings_manager.initialize = function(self)
  self.storage = backbone.useStorage(self.token, self.scope)

  if self.storage:get '__settings' == nil then
    self.storage:set('__settings', {})
  end

  local update_settings = true
  local addon_version = backbone.getAddonVersionNumber(self.token.name)

  if not backbone.isDevelopment() then
    local storedVersion = self.storage:get '__version' --[[@as number]]
    update_settings = (storedVersion or -1) < addon_version
  end

  if update_settings then
    local syncSettings
    ---
    ---Recursively synchronizes settings from a source table to a target table.
    ---
    ---@param source table
    ---@param target table
    ---
    syncSettings = function(source, target)
      for sourceKey, sourceValue in pairs(source) do
        -- Handle nested tables and lists.
        if type(sourceValue) == 'table' then
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
    self.storage:set('__version', addon_version)
  end
end

---
---Changes the storage scope for the settings manager.
---
---@param scope backbone.storage-scope
---
settings_manager.setScope = function(self, scope)
  if scope ~= 'account' and scope ~= 'realm' and scope ~= 'character' then
    throw('Invalid scope "%s", must be "account", "realm" or "character".', scope)
  end

  self.scope = scope
  self:initialize()
end

---
---Retrieves the current value of a setting.
---
---@param key string
---@return unknown
---
settings_manager.getValue = function(self, key)
  local value = self.storage:get('__settings/' .. tostring(key))

  if value == nil then
    throw('The key `%s` does not exist in the settings.', key)
  end
  
  return value
end

---
---Retrieves a value from a specific list setting.
---
---@param list string
---@param key string|number
---@return unknown
---
settings_manager.getValueFromList = function(self, list, key)
  ---@type backbone.list-setting
  local content = self.storage:get('__settings/' .. list)

  if type(content) ~= 'table' or not content.__list then
    throw('The list `%s` does not exist in the settings.', list)
  end
  
  return content[tostring(key)]
end

---
---Retrieves the default value for a setting.
---
---@param key string
---@return unknown
---
settings_manager.getDefaultValue = function(self, key)
  local value = self.defaults:get(key)

  if value == nil then
    throw('The key `%s` does not exist in the default settings.', key)
  end

  return value
end

---
---Retrieves a value from a specific default list setting.
---
---@param list string
---@param key string|number
---@return unknown
---
settings_manager.getDefaultValueFromList = function(self, list, key)
  ---@type backbone.list-setting
  local content = self.defaults:get(list)

  if type(content) ~= 'table' or not content.__list then
    throw('The list `%s` does not exist in the default settings.', list)
  end

  return content[tostring(key)]
end

---
---Sets the persistent value of a setting.
---
---@generic V
---
---@param key string
---@param value V
---@return V
---
settings_manager.setValue = function(self, key, value)
  local current_value = self:getValue(key)
  local default_value = self:getDefaultValue(key)
  
  if type(current_value) ~= type(default_value) then
    throw('The setting "%s" must be of type %s, got %s.',
      key, type(default_value), type(current_value)
    )
  end
  
  self.storage:set('__settings/' .. key, value)
  backbone.triggerCustomEvent(context.token,
    'SETTING_CHANGED/' .. self.token.name, { key = key, value = value }
  )
  
  return value
end

---
---Sets a persistent value within a list setting.
---
---@generic V
---
---@param list string
---@param key string|number
---@param value V
---
---@return V
---
settings_manager.setListValue = function(self, list, key, value)
  local default_content = self:getDefaultValue(list)

  if type(default_content) ~= 'table' or not default_content.__list then
    throw('The list `%s` does not exist in the default settings.', list)
  elseif type(value) ~= default_content.__type then
    throw('The list "%s" expect values of type %s, got %s.', default_content.__type, type(value))
  elseif key == '__list' or key == '__type' then
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
---Creates a special table structure representing a list setting with a defined value type.
---
---@param value_type 'boolean'|'string'|'number'
---@param elements array<string|number>
---@return backbone.list-setting
---
backbone.createListSetting = function(value_type, elements)
  if not array.contains({ 'boolean', 'string', 'number' }, value_type) then
    throw('Invalid value type `%s`, must be `boolean`, `string` or `number`.', value_type)
  end

  local default_value = switch(
    value_type, { boolean = true, number = 0, string = '' }
  )

  ---@type backbone.list-setting
  local list = { __list = true, __type = value_type }
  
  array.iterate(elements, function(_, key)
    if key ~= '__list' and key ~= '__type' then
      list[tostring(key)] = default_value
    end
  end)
  
  return list
end

---
---Retrieves or creates a settings manager for a given addon token.
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
    settings_manager:new(token, scope or 'account', defaults)
  )
end
