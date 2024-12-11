---@meta

--[[~ Updated: 2024/12/11 | Author(s): Gopher ]]

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

---@class Settings.VerticalLayoutCategory
---
local category = {}

---@return string name
---
category.GetName = function (self) end

---@param name string
---
category.SetName = function (self, name) end

---@return boolean hasParent
---
category.HasParentCategory = function (self) end

---@return Settings.VerticalLayoutCategory? parent
---
category.GetParentCategory = function (self) end

---@param parent Settings.VerticalLayoutCategory
---
category.SetParentCategory = function (self, parent) end

---@param enabled boolean
---
category.SetShouldSortAlphabetically = function (self, enabled) end
