--[[~ Updated: 2025/01/10 | Author(s): Gopher ]]
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
---Determines if the specified addon is loaded.
---
---@param addonName string
---@return boolean
---
backbone.isAddonLoaded = function(addonName)
  return select(2, C_AddOns.IsAddOnLoaded(addonName))
end

---
---Parse the metadata for the specified addon and key. The specified separator
---will be used to split the metadata into an array.
---
---@param addon string|number
---@param key string
---@param separator? string
---@return array<string>?
---
backbone.parseAddonMetadata = function(addon, key, separator)
  if separator ~= nil and type(separator) ~= 'string' then
    throw('Expected `separator` to be a string, got %s.', type(separator))
  end
  local metadata = C_AddOns.GetAddOnMetadata(addon, key)
  if type(metadata) == 'string' and string.len(metadata) > 0 then
    local data = { string.split(separator or ',', metadata) }
    array.iterate(data,
      function(_, value) return string.trim(value) end
    )
    return data
  end
end
