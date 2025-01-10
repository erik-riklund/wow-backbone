---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/09 | Author(s): Gopher ]]
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

local events = ({} --[[@as table<string, backbone.observable>]])
local eventFrame = CreateFrame 'Frame' --[[@as Frame]]
eventFrame:RegisterEvent 'ADDON_LOADED'

---
---
---
eventFrame:SetScript(
  'OnEvent', function(_, eventName, ...)
    local payload = { ... }
    -- TODO: implement.
  end
)

---
---
---
backbone.registerEventListener = function() end

---
---
---
backbone.removeEventListener = function() end

---
---
---
---@param addonName string
---@param callback backbone.observer-callback
---
backbone.onAddonReady = function(addonName, callback)
  if backbone.isAddonLoaded(addonName) then
    backbone.queueTask(function() callback({}) end)
    return -- the addon is already loaded, exit early.
  end
  -- TODO: implement.
end
