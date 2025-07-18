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

---
---A predefined set of color codes for text formatting.
---
---@enum (key) backbone.color
---
local palette =
{
  normal    = 'F5DEB3', -- Warm, wheat color.
  neutral   = 'FFFFFF', -- Plain white.
  faded     = 'BEBEBE', -- Light gray.
  info      = '4682B4', -- Steel blue.
  error     = 'CC4733', -- Dark red-orange.
  highlight = 'FCD462', -- Soft golden-yellow.
  success   = '00AC00', -- Bright green.
}

---
---Applies color formatting to a given string using custom tags or hex codes.
---
---@param text string
---
backbone.colorizeText = function(text)
  text = text
      :gsub('<color:[ ]*#([^>]+)>',
        function(color) return '|cFF' .. color end
      )
      :gsub('<([^/>]+)>',
        function(colorCode)
          return switch(
            colorCode,
            {
              default = function()
                return '<' .. colorCode .. '>'
              end,
              [hashmap.keys(palette)] = function()
                return '|cFF' .. palette[colorCode]
              end
            }
          )
        end
      )
      :gsub('</end>', '|r')

  return text
end

---
---Prints a message to the chat frame,
---automatically applying the default `normal` color.
---
---@param message unknown
---
backbone.print = function(message)
  print(backbone.colorizeText('<normal>' .. tostring(message) .. '</end>'))
end

---
---Prints the provided message, formatted using the `string.format` function.
---The default `normal` color is applied to the resulting message.
---
---@param message string
---@param ... string|number
---
backbone.printf = function(message, ...)
  backbone.print(string.format(message, ...))
end
