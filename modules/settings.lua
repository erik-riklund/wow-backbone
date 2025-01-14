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
---@field defaults backbone.storage-unit
---@field storage backbone.storage-unit
---
local manager = {}

---
---
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
  return inherit(self, { defaults = defaults, storage = variables })
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
    local storedVersion = variables:get('__settings/__version')
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
        -- If the value in the source is a table, handle nested or toggleable logic.
        if type(sourceValue) == 'table' then
          -- Ensure the target has a table for this key.
          if target[sourceKey] == nil then
            target[sourceKey] = {}
          end

          if sourceValue.__toggleable then
            -- Synchronize toggleable states: add missing toggle states to the target.
            for toggleKey, toggleState in pairs(sourceValue) do
              if target[sourceKey][toggleKey] == nil then
                target[sourceKey][toggleKey] = toggleState
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

      if not target.__toggleable then
        for targetKey in pairs(target) do
          if source[targetKey] == nil then
            target[targetKey] = nil -- remove keys that don't exist in the source.
          end
        end
      end
    end

    syncSettings(defaults.data, variables:get('__settings'))
    variables:set('__settings/__version', addonVersion)
  end
end

---
---
---
---@param key string
---@return unknown
---
manager.getValue = function(self, key)
  ---@diagnostic disable-next-line: missing-return
end

---
---
---
---@param list string
---@param key string|number
---@return unknown
---
manager.getValueFromList = function(self, list, key)
  return self:getValue(string.format('%s/%s', list, tostring(key)))
end

---
---
---
---@param key string
---@return unknown
---
manager.getDefaultValue = function(self, key)
  ---@diagnostic disable-next-line: missing-return
end

---
---
---
---@param list string
---@param key string|number
---@return unknown
---
manager.getDefaultValueFromList = function(self, list, key)
  return self:getDefaultValue(string.format('%s/%s', list, tostring(key)))
end

---
---
---
---@param key string
---@return backbone.toggleable-list
---
manager.getToggleableList = function(self, key)
  ---@diagnostic disable-next-line: missing-return
end

---
---
---
---@param token backbone.token
---@param defaults table
---
backbone.useSettings = function(token, defaults)
  if hashmap.contains(registry, token) then
    throw('A settings manager has already been registered for the provided token (%s).', token.name)
  end
  return hashmap.set(registry, token, manager:new(token, defaults))
end
