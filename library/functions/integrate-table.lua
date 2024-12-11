
--[[~ Updated: 2024/12/02 | Author(s): Gopher ]]

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

---@param base table
---@param source table
---@param mode? 'strict'|'replace'|'skip'
---
---@return table
---
---Merges the contents of one table (`source`) into another (`base`) with configurable handling
---for key collisions. The integration process depends on the specified `mode`:
---
---* `strict` Throws an error if a key in the `source` table already exists in the `base` table.
---* `replace` Overwrites values in the `base` table with those from the `source`.
---* `skip` Leaves existing keys in the `base` table unchanged.
---
---By default, the `strict` mode is used. The updated `base` table is returned.
---
backbone.integrateTable = function (base, source, mode)
  mode = mode or 'strict'

  for key, value in pairs (source) do
    if mode == 'replace' or base[key] == nil then
      base[key] = value
    elseif mode == 'strict' then
      backbone.throw ('The key "%s" already exists in the base table.', key)
    end
  end

  return base
end

---@param base table
---@param sources table
---@param mode? 'skip'|'replace'|'strict'
---
---@return table
---
---Combines multiple tables (`sources`) into a single `base` table using a configurable merge strategy.
---This function applies the specified `mode` to control how conflicts between keys are resolved, iterating
---through each table in the `sources` collection.
---
---* `strict` Throws an error if a key in the `source` table already exists in the `base` table.
---* `replace` Overwrites values in the `base` table with those from the `source`.
---* `skip` Leaves existing keys in the `base` table unchanged.
---
---By default, the `strict` mode is used. The updated `base` table is returned.
---
backbone.integrateTables = function (base, sources, mode)
  Vector (sources):forEach (
    function (index, source)
      backbone.integrateTable (base, source, mode)
    end
  )

  return base
end
