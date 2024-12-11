
--[[~ Updated: 2024/11/30 | Author(s): Gopher ]]

--Backbone - A World of Warcraft Addon Framework
--Copyright (C) 2024 Erik Riklund (Gopher)
--
--This program is free software: you can redistribute it and/or modify it under the terms
--of the GNU General Public License as published by the Free Software Foundation, either
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU General Public License <https://www.gnu.org/licenses/> for more details.

---@param target table
---@param parents? string
---@param result? table
---
---@return table
---
---Transforms a nested table into a single-level table by representing its structure through
---composite keys. The function recursively traverses the input table, combining parent keys
---with child keys using a `/` separator to create a flattened representation.
---
backbone.flattenTable = function (target, parents, result)
  if type (target) ~= 'table' then
    error ('Expected a table for argument #1 (target).', 3)
  end

  result = result or {}
  for key, value in pairs (target) do
    local modifiedKey = string.gsub (key, '[$]', '')
    local resultKey = (parents and string.format ('%s/%s', parents, modifiedKey)) or modifiedKey

    if type (value) == 'table' and (string.sub (key, 1, 1) ~= '$') then
      backbone.flattenTable (value, resultKey, result)
    else
      result[resultKey] = value
    end
  end

  return result
end
