--[[~ Updated: 2025/07/17 | Author(s): Gopher ]]
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

assert(throw == nil,
  'Global variable conflict: `throw` has already been defined.'
)

---
---Throws an error in development mode,
---and prints a generic error message in production mode.
---
---@param exception string
---@param ... string|number
---
_G.throw = function(exception, ...)
  if backbone.isDevelopment() then
    error(... and string.format(exception, ...) or exception, 2)
  else
    -- TODO: implement user-friendly error handling.

    backbone.printf(
      '<error>[Backbone] An internal error has occured.</end>\n'
      .. 'Try /reload to see if the issue persists.'
    )
  end
end
