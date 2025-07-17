--[[~ Updated: 2025/07/16 | Author(s): Gopher ]]
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

assert(stringBuffer == nil,
  'Global variable conflict: `stringBuffer` has already been defined.'
)

---
---A utility for building and manipulating strings, similar to a mutable string builder.
---
---@class backbone.string-buffer
---@field content string[]
---
_G.stringBuffer = {}

---
---Creates a new string buffer instance.
---
---@private
---@return backbone.string-buffer
---
stringBuffer.new = function(self)
  return inherit(self, { content = {} })
end

---
---Appends a string as a new line to the buffer.
---
---@param string string
---
stringBuffer.appendLine = function(self, string)
  array.append(self.content, string)
end

---
---Appends a string to the current or specified line in the buffer.
---
---@param string string
---@param lineIndex? number
---
stringBuffer.append = function(self, string, lineIndex)
  if self.content[1] == nil then
    array.append(self.content, string)
  else
    lineIndex = lineIndex or #self.content

    if self.content[lineIndex] == nil then
      throw('The specified line (%d) does not exist.', lineIndex)
    end
    
    self.content[lineIndex] = self.content[lineIndex] .. string
  end
end

---
---Merges all lines in the buffer into a single string, using an optional separator.
---
---@param separator? string
---@return string
---
stringBuffer.merge = function(self, separator)
  return table.concat(self.content, separator or '\n')
end

---
---Processes each line in the buffer using a callback function.
---
---@param callback fun(line: string): string?
---
stringBuffer.process = function(self, callback)
  array.iterate(self.content,
    function(_, line) return callback(line) end
  )
end
