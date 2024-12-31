--[[~ Updated: 2024/12/31 | Author(s): Gopher ]]
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
---Perform garbage collection when the player enters the world.
---
backbone.registerEventListener(
  'PLAYER_ENTERING_WORLD', function()
    collectgarbage 'collect'
  end
)

---
---Perform garbage collection when the player goes AFK.
---
backbone.registerEventListener(
  'PLAYER_FLAGS_CHANGED', function(payload)
    local unit = payload[1] --[[@as UnitToken]]
    if unit == 'player' and UnitIsAFK(unit) then
      collectgarbage 'collect'
    end
  end
)
