--[[~ Updated: 2025/01/21 | Author(s): Gopher ]]
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
---@type 'development'|'production'
---
local environment = 'development'

---
---@return boolean
---
backbone.isDevelopment = function()
  return environment == 'development'
end

---
---@param mode 'development'|'production'
---
backbone.setEnvironment = function(mode)
  if mode ~= 'development' and mode ~= 'production' then
    throw('Expected `mode` to be one of "development" or "production", got "%s".', mode)
  end
  environment = mode
end
