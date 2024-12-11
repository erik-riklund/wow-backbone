--[[~ Updated: 2024/12/11 | Author(s): Gopher ]]

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
---@param key T
---@param cases Backbone.Switch.Cases<T>
---@param ... unknown
---
---@return unknown?
---
---Provides a table-based switch statement operator, which can be used to select a value based
---on a given key. The switch statement allows for multiple cases and an optional default case,
---making it a powerful tool for handling different scenarios based on input values.
---
backbone.switch = function (key, cases, ...)
  if not type (cases) == 'table' then
    error ('Expected a table for argument #2 (cases).', 3)
  end

  ---@type unknown?
  local case = backbone.when (cases[key] ~= nil, cases[key], cases.default)
  return (type (case) == 'function' and case (...)) or case
end
