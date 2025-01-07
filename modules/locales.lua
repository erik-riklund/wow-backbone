---@class __backbone
local context = select(2, ...)

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

--=============================================================================
-- LOCALE HANDLER:
--
-- This module manages the registration and retrieval of localized strings for addons,
-- enabling multilingual support. It allows external contributors to register strings,
-- ensuring that existing strings are not overwritten.
--=============================================================================

local contributed_strings = ({} --[[@as table<string, backbone.locale-registry>]])

---
---Register any contributed localized strings once the addon is fully initialized.
---
array.insert(
  context.addon_initializers,
  ---@param addon backbone.addon
  function(addon)
    addon:onReady(
      function()
        local addon_name = addon:getName()
        if dictionary.has(contributed_strings, addon_name) then
          dictionary.foreach(
            contributed_strings[addon_name],
            function(locale, strings)
              addon:registerLocalizedStrings(locale, strings)
            end
          )
          dictionary.drop(contributed_strings, addon_name)
        end
      end
    )
  end
)

---
---Retrieve the localized string with the specified key.
---
---@param key string
---@return string
---
__addon.getLocalizedString = function(self, key)
  assert(
    self.strings ~= nil, string.format(
      'No strings have been registered for addon "%s".', self:getName()
    )
  )
  return (self.strings[backbone.activeLocale] and self.strings[backbone.activeLocale][key])
      or (self.strings['enUS'] and self.strings['enUS'][key])
      or string.format('[Missing localized string "%s" (%s)]', key, self:getName())
end

---
---Register a set of localized strings for the addon.
---These strings will not overwrite existing strings.
---
---@param locale backbone.locale
---@param strings backbone.localized-strings
---
__addon.registerLocalizedStrings = function(self, locale, strings)
  self.strings = self.strings or {}
  self.strings[locale] = self.strings[locale] or {}

  dictionary.combine(self.strings[locale], strings)
end

---
---Contribute localized strings to an addon. These strings will be registered
---after the addon have been initialized, and will not overwrite existing strings.
---
---@param addon_name string
---@param locale backbone.locale
---@param strings backbone.localized-strings
---
backbone.contributeLocalizedStrings = function(addon_name, locale, strings)
  if select(2, C_AddOns.IsAddOnLoaded(addon_name)) then
    local addon = context.getAddon(addon_name)
    addon:registerLocalizedStrings(locale, strings)
  else
    contributed_strings[addon_name] = contributed_strings[addon_name] or {}
    contributed_strings[addon_name][locale] = contributed_strings[addon_name][locale] or {}

    dictionary.combine(contributed_strings[addon_name][locale], strings)
  end
end
