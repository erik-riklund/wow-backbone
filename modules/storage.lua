--[[~ Updated: 2025/01/11 | Author(s): Gopher ]]
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
---
---
---@param token backbone.token
---@param scope? backbone.storage-scope
---
backbone.useStorage = function(token, scope)
  assert(
    backbone.isAddonLoaded(token.name), string.format(
      'The addon "%s" is not fully loaded, saved variables are not available.', token.name
    )
  )
  assert(
    scope == nil or scope == 'account' or scope == 'character', string.format(
      'Invalid scope "%s", must be "account" or "character".', scope
    )
  )
  
end
