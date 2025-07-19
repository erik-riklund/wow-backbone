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
---The locale used as a fallback if a string is not found in the current locale.
---
local default_locale = 'enUS'

---
---A table mapping addons to their respective locale managers.
---
---@type table<backbone.token, backbone.locale-manager>
---
local managers = {}

---
---Represents a manager for handling localized strings for a specific addon.
---
---@class backbone.locale-manager
---@field token backbone.token
---@field locales table<backbone.locale, table<string, string>>
---
local locale_manager = {}

---
---Creates a new `backbone.locale-manager` instance.
---
---@private
---@param token backbone.token
---
locale_manager.new = function(self, token)
  return inherit(self, { token = token, locales = {} })
end

---
---Registers a set of localized strings for a specific locale.
---
---@param locale backbone.locale
---@param strings table<string, string>
---
locale_manager.register = function(self, locale, strings)
  self.locales[locale] = self.locales[locale] or {}

  for key, value in pairs(strings) do
    if not hashmap.contains(self.locales[locale], key) then
      if locale ~= default_locale and not hashmap.contains(self.locales[default_locale], key) then
        throw('The default locale does not contain the key `%s` (%s).', key, self.token.name)
      end

      self.locales[locale][key] = value
    end
  end
end

---
---Retrieves a localized string based on the current game locale.
---
---@param key string
---@return string
---
locale_manager.get = function(self, key)
  local active_locale = self.locales[backbone.currentLocale]
  local fallback_locale = self.locales[default_locale]

  return (type(active_locale) == 'table' and active_locale[key])
      or (type(fallback_locale) == 'table' and fallback_locale[key])
      or string.format('[Missing localized string: %s (%s)]', key, self.token.name)
end

---
---Retrieves the locale manager for a given addon token, creating it if it doesn't exist.
---
---@param token backbone.token
---
backbone.getLocaleManager = function(token)
  if not context.validateToken(token) then
    throw 'The provided token is not registered.'
  end
  
  return managers[token] or hashmap.set(
    managers, token, locale_manager:new(token)
  )
end

---
---Registers localized strings for an addon after it has been loaded.
---
---@param addon string
---@param locale backbone.locale
---@param strings table<string, string>
---
backbone.registerLocalizedStrings = function(addon, locale, strings)
  backbone.onAddonLoaded(addon, function()
      local token = context.getToken(addon)
      local manager = managers[token] or throw(
        'No locale manager available for addon `%s`.', addon
      )
      manager:register(locale, strings)
    end
  )
end
