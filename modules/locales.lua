---@class Backbone
local context = select(2, ...)

--[[~ Updated: 2024/12/06 | Author(s): Gopher ]]

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

local locales = new 'Dictionary'

---@param plugin Backbone.Plugin
---@param locale Backbone.LocaleCode
---@param strings table
---
local registerStrings = function (plugin, locale, strings)
  if not locales:hasEntry (plugin) then
    locales:setEntry (plugin, {})
  end
  
  local registeredStrings = locales:getEntry (plugin) --[[@as table]]
  registeredStrings[locale] = registeredStrings[locale] or {}

  backbone.integrateTable (registeredStrings[locale], strings, 'skip')
end

---@param plugin Backbone.Plugin
---@param key string
---
local getLocalizedString = function (plugin, key)
  if not locales:hasEntry (plugin) then
    return string.format (
      'No strings registered for plugin "%s".', plugin:getName ()
    )
  end
  local registeredStrings = locales:getEntry (plugin) --[[@as table]]

  return (registeredStrings[backbone.activeLocale] and registeredStrings[backbone.activeLocale][key])
      or (registeredStrings.enUS and registeredStrings.enUS[key])
      or string.format('The string "%s" is not registered for plugin "%s".', key, plugin:getName ())
end

-- FRAMEWORK API --

---@param pluginName string
---@param locale Backbone.LocaleCode
---@param strings table
---Registers the provided strings for the specified plugin and locale.
---
backbone.registerLocalizedStrings = function (pluginName, locale, strings)
  local isLoaded = select (2, C_AddOns.IsAddOnLoaded (pluginName)) --[[@as boolean]]

  if isLoaded then
    ---@type Backbone.Plugin
    local plugin = context.plugins:getEntry (string.lower (pluginName))

    return registerStrings (plugin, locale, strings) -- exit early.
  end

  local listenerId = string.format (
    '%s/%s/%s', pluginName, locale, GetTimePreciseSec()
  )

  context.plugin:registerChannelListener (
    'PLUGIN_LOADED', {
      id = listenerId,
      callback = function (loadedPlugin)
        ---@cast loadedPlugin Backbone.Plugin
        
        if loadedPlugin:getName () == pluginName then
          registerStrings (loadedPlugin, locale, strings)
          context.plugin:removeChannelListener ('PLUGIN_LOADED', listenerId)
        end
      end
    }
  )
end

---@param pluginName string
---@param key string
---@return string
---
---Returns the localized string for the specified plugin and key.
---
backbone.getLocalizedString = function (pluginName, key)
  local pluginId = string.lower (pluginName)
  if not context.plugins:hasEntry (pluginId) then
    return string.format ('The plugin "%s" is not loaded.', pluginName)
  end

  return context.plugins:getEntry (pluginId) --[[@as Backbone.Plugin]]:getLocalizedString (key)
end

-- PLUGIN API --

---@class Backbone.Plugin
local localesAPI = context.pluginAPI

---@param locale Backbone.LocaleCode
---@param strings table
---Registers the provided strings for the specified locale.
---
localesAPI.registerLocalizedStrings = function (self, locale, strings)
  registerStrings (self, locale, strings)
end

---@param key string
---Returns the localized string for the specified key.
---
localesAPI.getLocalizedString = function (self, key)
  return getLocalizedString (self, key)
end
