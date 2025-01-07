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

assert(backbone == nil,
  'Global variable conflict: `backbone` has already been defined.'
)

---
---
---
---@class backbone
---
_G.backbone =
{
  ---
  ---Specifies the currently active locale.
  ---@type backbone.locale
  ---
  activeLocale = GetLocale(),

  ---
  ---Specifies the current expansion level as a numeric value.
  ---@see EXPANSION_LEVEL
  ---@type number
  ---
  currentExpansion = GetExpansionLevel()
}
