---@meta

--[[~ Updated: 2024/12/28 | Author(s): Gopher ]]
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
---Represents a single addon within the Backbone ecosystem.
---
---@class backbone.addon
---
---@field private strings backbone.addon-strings
---@field private variables backbone.addon-variables
---@field private settings table
---

---
---Represents the storage of variables associated with an addon.
---
---@class backbone.addon-variables
---
---@field account table
---@field character table
---

---
---Represents the repository of localized strings associated with an addon.
---
---@class backbone.addon-strings : { [backbone.locale]: backbone.localized-strings }
---
