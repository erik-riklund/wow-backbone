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

assert(hashmap == nil,
  'Global variable conflict: `hashmap` has already been defined.'
)

---
---A handy set of utility functions for working with hashmaps. Built-in access
---checks make sure everything runs smoothly and avoids errors.
---
---@class backbone.hashmap
---
_G.hashmap = {}
