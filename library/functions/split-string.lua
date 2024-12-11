--[[~ Updated: 2024/12/11 | Author(s): Gopher ]]

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

---@param target string
---@param separator string
---@param pieces? number
---
---@return Vector components
---
---Splits a string into substrings based on the given `separator`, removing any leading or trailing
---whitespace from each substring. If a limit on the number of parts is provided, the split will
---produce no more than `pieces` substrings.
---
backbone.splitString = function (target, separator, pieces)
  local components = Vector {
    string.split(separator, target, pieces)
  }
  components:forEach(
    function (_, element) return string.trim (element) end
  )

  return components
end
