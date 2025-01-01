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
---?
---
---@class backbone.addon
---
---@field private variables backbone.addon-variables The addon's saved variables, only available when the addon is fully initialized.
---

---
---?
---
---@class backbone.addon-variables
---
---@field account table The addon's account-wide saved variables.
---@field character table The addon's character-specific saved variables.
---

---
---?
---
---@class backbone.addon-settings: { [string]: unknown }
---
