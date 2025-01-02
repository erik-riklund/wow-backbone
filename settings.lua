---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/01 | Author(s): Gopher ]]
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

--=============================================================================
-- COMPONENT > LIST SETTING:
-- <add description of the module>
--=============================================================================

---
---?
---
---@class backbone.list-setting
---
local listSetting =
{

}

---
---?
---
local createListSetting = function() end

--=============================================================================
-- SETTINGS MANAGER:
-- <add description of the module>
--=============================================================================

---
---?
---
__addon.setDefaultSettings = function(self, settings) end

---
---?
---
__addon.getListSetting = function(self, key) end

---
---?
---
__addon.getSimpleSetting = function(self, key) end

---
---?
---
__addon.setSimpleSetting = function(self, key, value) end
