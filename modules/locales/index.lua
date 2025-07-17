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

local defaultLocale = 'enUS'

---
---@type table<backbone.token, backbone.locale-manager>
---
local localeManagers = {}

---
---@class backbone.locale-manager
---@field token backbone.token
---@field locales table<backbone.locale, table<string, string>>
---
local localeManager = {}

---
---@private
---@param token backbone.token
---
localeManager.new = function(self, token)
  return inherit(self, { token = token, locales = {} })
end

---
---@param locale backbone.locale
---@param strings table<string, string>
---
localeManager.register = function(self, locale, strings)
  self.locales[locale] = self.locales[locale] or {}
  for key, value in pairs(strings) do
    if not hashmap.contains(self.locales[locale], key) then
      if locale ~= defaultLocale and not hashmap.contains(self.locales[defaultLocale], key) then
        throw('The default locale does not contain the key `%s` (%s).', key, self.token.name)
      end
      self.locales[locale][key] = value
    end
  end
end

---
---@param key string
---@return string
---
localeManager.get = function(self, key)
  local activeLocale = self.locales[backbone.currentLocale]
  local fallbackLocale = self.locales[defaultLocale]

  return (type(activeLocale) == 'table' and activeLocale[key])
      or (type(fallbackLocale) == 'table' and fallbackLocale[key])
      or string.format('[Missing localized string: %s (%s)]', key, self.token.name)
end

---
---@param token backbone.token
---
backbone.getLocaleManager = function(token)
  if not context.validateToken(token) then
    throw 'The provided token is not registered.'
  end
  return localeManagers[token] or hashmap.set(
    localeManagers, token, localeManager:new(token)
  )
end

---
---@param addon string
---@param locale backbone.locale
---@param strings table<string, string>
---
backbone.registerLocalizedStrings = function(addon, locale, strings)
  backbone.onAddonLoaded(addon, function()
      local token = context.getToken(addon)
      local manager = localeManagers[token] or throw(
        'No locale manager available for addon `%s`.', addon
      )
      manager:register(locale, strings)
    end
  )
end
