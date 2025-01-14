---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/14 | Author(s): Gopher ]]
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
---A table of addon loaders, each representing a handler for a specific loading condition.
---
---@type table<string, backbone.addon-loader>
---
local loaders =
{
  ---
  ---Handles loading of addons based on specific events.
  ---
  OnEvent = function(index, metadata)
    array.iterate(metadata, function(_, eventName)
      backbone.registerEventListener(
        eventName, {
          persistent = false,
          callback = function()
            if not C_AddOns.IsAddOnLoaded(index) then
              C_AddOns.LoadAddOn(index)
            end
          end
        }
      )
    end)
  end,

  ---
  ---Handles loading of addons when a specific addon is loaded.
  ---
  OnAddonLoaded = function(index, metadata)
    array.iterate(metadata, function(_, addonName)
      backbone.onAddonLoaded(addonName, function()
        if not C_AddOns.IsAddOnLoaded(index) then
          C_AddOns.LoadAddOn(index)
        end
      end)
    end)
  end,

  ---
  ---Handles loading of addons when a specific service is requested.
  ---
  OnServiceRequest = function(index, metadata)
    local addonName = C_AddOns.GetAddOnInfo(index)
    array.iterate(metadata, function(_, serviceName)
      context.registerLoadableService(addonName, serviceName)
    end)
  end
}

---
---Iterates over all load-on-demand addons and applies the appropriate
---load handlers based on the conditions specified in the addon's metadata.
---
for index = 1, C_AddOns.GetNumAddOns() do
  if C_AddOns.IsAddOnLoadOnDemand(index) then
    hashmap.iterate(loaders,
      function(condition, handler)
        local metadata = backbone.parseAddonMetadata(
          index, string.format('X-Load-%s', condition)
        )
        if metadata ~= nil then handler(index, metadata) end
      end
    )
  end
end
