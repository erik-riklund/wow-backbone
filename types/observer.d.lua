---@meta

--[[~ Updated: 2024/12/29 | Author(s): Gopher ]]
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
---Represents an event listener, used to react to specific events.
---
---@class backbone.observer
---
---@field callback backbone.observer-callback The function to be executed when the event is triggered.
---@field persistent? boolean If `false`, the listener will be removed after the first execution (default: `true`).
---

---
---Represents the callback of an event listener.
---
---@alias backbone.observer-callback fun(payload: table)
---
