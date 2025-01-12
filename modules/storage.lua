---@class __backbone
local context = select(2, ...)

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
    context.validateToken(token), 'The provided token "%s" is invalid.'
  )
  assert(
    backbone.isAddonLoaded(token.name), string.format(
      'Saved variables are not available yet for the addon "%s".', token.name
    )
  )

  scope = scope or 'account'
  assert(
    array.contains({ 'account', 'character' }, scope), string.format(
      'Invalid scope "%s", must be "account" or "character".', scope
    )
  )
  
  local variable = string.format(
    '%s%sVariables', token.name, capitalize(scope)
  )
  if _G[variable] == nil then _G[variable] = {} end
  return storageUnit:new(_G[variable])
end
