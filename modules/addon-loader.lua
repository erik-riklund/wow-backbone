---@class __backbone
local context = select(2, ...)

---@diagnostic disable: invisible

--[[~ Updated: 2025/01/04 | Author(s): Gopher ]]
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
-- ADDON LOADER:
--
-- This module handles the conditional loading of addons based on specific
-- triggers such as game events or service requests. It ensures addons are
-- loaded only when required, optimizing performance and resource usage.
--=============================================================================

---
---Break down a metadata string into its component parts.
---
---@param metadata string
---@return string[]
---
local parseAddonMetadata = function(metadata)
  local data = { string.split(',', metadata) }
  array.foreach(data, function(_, value) return string.trim(value) end)

  return data
end

---
---The available handlers for loading addons.
---
---@type table<string, fun(index: number, metadata: string)>
---
local load_handlers =
{
  ---
  ---Responsible for loading addons on specific events.
  ---
  OnEvent = function(index, metadata)
    array.foreach(
      parseAddonMetadata(metadata), function(_, event_name)
        backbone.registerEventListenerOnce(
          event_name, function()
            if not C_AddOns.IsAddOnLoaded(index) then C_AddOns.LoadAddOn(index) end
          end
        )
      end
    )
  end,

  ---
  ---Responsible for loading addons when another specific addon is loaded.
  ---
  onAddonLoaded = function(index, metadata)
    array.foreach(
      parseAddonMetadata(metadata), function(_, addon_name)
        backbone.onAddonReady(addon_name, function()
          if not C_AddOns.IsAddOnLoaded(index) then C_AddOns.LoadAddOn(index) end
        end)
      end
    )
  end,

  ---
  ---Responsible for loading addons on service requests.
  ---
  OnServiceRequest = function(index, metadata)
    local addon_name = C_AddOns.GetAddOnInfo(index)
    array.foreach(
      parseAddonMetadata(metadata), function(_, service_name)
        context.registerLoadableService(addon_name, service_name)
      end
    )
  end
}

---
---Apply load handlers for addons that should be conditionally loaded.
---
for index = 1, C_AddOns.GetNumAddOns() do
  if C_AddOns.IsAddOnLoadOnDemand(index) then
    dictionary.foreach(
      load_handlers, function(name, handler)
        local metadata = C_AddOns.GetAddOnMetadata(index, 'X-Load-' .. name)
        if type(metadata) == 'string' and #metadata > 0 then
          handler(index, metadata)
        end
      end
    )
  end
end
