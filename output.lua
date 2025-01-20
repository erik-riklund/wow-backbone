--[[~ Updated: 2025/01/07 | Author(s): Gopher ]]
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
---The color palette used to visually enhance messages.
---
local palette =
{
  normal    = 'F5DEB3', -- Warm, wheat color.
  neutral   = 'FFFFFF', -- Plain white.
  faded     = 'BEBEBE', -- Neutral light gray.
  info      = '4682B4', -- Steel blue.
  error     = 'CC4733', -- Dark red-orange.
  highlight = 'FCD462', -- Soft golden-yellow.
  success   = '00AC00', -- Bright green.
}

---
---Enhances text with colors using special tags.
---
---* Use `<color:#RRGGBB>` to set custom colors (replace `#RRGGBB` with your color code).
---* The predefined tags `<normal>`, `<error>`, `<highlight>`, `<success>`,
---`<neutral>` and `<info>` automatically apply specific colors.
---* End color formatting with `</end>` to reset to default.
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
              [{ 'normal', 'error', 'highlight', 'success', 'neutral', 'faded', 'info' }] = function()
                return '|cFF' .. palette[colorCode]
              end,

              default = function() return '<' .. colorCode .. '>' end,
            }
          )
        end
      )
      :gsub('</end>', '|r')

  return text
end

---
---Print a message to the default chat frame. The message can be colorized to improve readability.
---
---* Use `<color:#RRGGBB>` to set custom colors (replace `#RRGGBB` with your color code).
---* The predefined tags `<normal>`, `<error>`, `<highlight>`, `<success>`,
---`<neutral>` and `<info>` automatically apply specific colors.
---
---@param message unknown
---
backbone.print = function(message)
  print(backbone.colorizeText('<normal>' .. tostring(message) .. '</end>'))
end

---
---Formats and prints a message with colorized output.
---
---* Uses the `string.format` function, letting you include placeholders (`%s`, `%d`, etc.) in your message,
---which are replaced by the additional arguments.
---* Use `<color:#RRGGBB>` to set custom colors (replace `#RRGGBB` with your color code).
---* The predefined tags `<normal>`, `<error>`, `<highlight>`, `<success>`,
---`<neutral>` and `<info>` automatically apply specific colors.
---
---@param message string
---@param ... string|number
---
backbone.printf = function(message, ...)
  backbone.print(string.format(message, ...))
end
