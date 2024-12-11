--[[~ Updated: 2024/12/10 | Author(s): Gopher ]]

--Backbone - A World of Warcraft addon framework
--Copyright (C) 2024 Erik Riklund (Gopher)
--
--This program is free software: you can redistribute it and/or modify it under the terms
--of the GNU General Public License as published by the Free Software Foundation, either
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU General Public License <https://www.gnu.org/licenses/> for more details.

---@generic T
---
---@param condition boolean
---@param onTrue T
---@param onFalse T
---
---@return T
---
---Provides a concise way to return one of two values based on a boolean condition. This function
---is useful in situations where Lua's built-in short-circuit operators does not work as expected.
---
---```lua
----- always assigns `true` as `false` short-circuits the expression.
---local value = (someValue == nil and false) or true
---```
---
backbone.when = function (condition, onTrue, onFalse)
  local value = onTrue
  if condition == false then value = onFalse end

  return value
end
