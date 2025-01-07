---@meta

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

---
---Represents an observer, used to react to notifications from an observable object.
---
---@class backbone.observer
---
---@field callback backbone.observer-callback
---@field persistent? boolean
---

---
---Represents the callback function for an observer.
---
---@alias backbone.observer-callback fun(payload: table)
---
