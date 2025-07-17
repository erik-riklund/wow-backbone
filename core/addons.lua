--[[~ Updated: 2025/07/17 | Author(s): Gopher ]]
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
---Checks if a specific addon is currently loaded.
---
---@param addon string|number
---@return boolean
---
backbone.isAddonLoaded = function(addon)
  return select(2, C_AddOns.IsAddOnLoaded(addon))
end

---
---Retrieves the version number of an addon as a comparable number.
---
---@param addon string|number
---@return number
---
backbone.getAddonVersionNumber = function(addon)
  local version = C_AddOns.GetAddOnMetadata(addon, 'Version')

  if type(version) ~= 'string' or string.len(version) == 0 then
    return 0 -- no version is specified in the addon metadata.
  end

  local major, minor, patch = string.split('.', version)
  return (tonumber(major) * 10000) + (tonumber(minor or 0) * 100) + tonumber(patch or 0)
end

---
---Parses a string from an addon's metadata using the specified separator (default: `,`).
---
---@param addon string|number
---@param key string
---@param separator? string
---
---@return array<string>?
---
backbone.parseAddonMetadata = function(addon, key, separator)
  if separator ~= nil and type(separator) ~= 'string' then
    throw('Expected `separator` to be a string, got %s.', type(separator))
  end
  
  local metadata = C_AddOns.GetAddOnMetadata(addon, key)
  
  if type(metadata) == 'string' and string.len(metadata) > 0 then
    local data = { string.split(separator or ',', metadata) }
    array.iterate(data, function(_, value) return string.trim(value) end)
    
    return data
  end
end
