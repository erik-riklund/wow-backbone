---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2024/12/30 | Author(s): Gopher ]]
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

local dictionary = backbone.utils.dictionary

--=============================================================================
-- LOCALE HANDLER:
-- <add description of the module>
--=============================================================================

--=============================================================================
-- STORAGE MANAGER:
-- <add description of the module>
--=============================================================================

--=============================================================================
-- SERVICE MANAGER:
-- <add description of the module>
--=============================================================================

--=============================================================================
-- ADDON LOADER:
-- <add description of the module>
--=============================================================================

---
---!
---
---@type table<string, fun(index: number, metadata: string)>
---
local load_handlers =
{
  OnEvent = function(index, metadata)
    backbone.print '"OnEvent" load handler not implemented.'
  end
}

---
---Apply load handlers for addons that should be conditionally loaded.
---
for index = 1, C_AddOns.GetNumAddOns() do
  if C_AddOns.IsAddOnLoadOnDemand(index) then
    dictionary.forEach(
      load_handlers, function(name, handler)
        local metadata = C_AddOns.GetAddOnMetadata(index, 'X-Load-' .. name)
        if type(metadata) == 'string' and #metadata > 0 then handler(index, metadata) end
      end
    )
  end
end
