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

assert(stringBuffer == nil,
  'Global variable conflict: `stringBuffer` has already been defined.'
)

---
---Represents a string buffer that provide methods for incrementally
---building and manipulating a string.
---
---@class backbone.string-buffer
---@field content string[]
---
_G.stringBuffer = {}

---
---Create a new string buffer.
---
---@return backbone.string-buffer
---
stringBuffer.new = function(self)
  return inherit(self, { content = {} })
end

---
---Append a new line to the string buffer.
---
---@param string string
---
stringBuffer.appendLine = function(self, string)
  array.append(self.content, string)
end

---
---Append a string to a specific line of the string buffer. If `lineIndex`
---is not provided, the string will be appended to the last line.
---
---@param string string
---@param lineIndex? number
---
stringBuffer.append = function(self, string, lineIndex)
  if self.content[1] == nil then
    array.append(self.content, string)
  else
    lineIndex = lineIndex or #self.content
    assert(
      self.content[lineIndex] ~= nil, string.format(
        'The specified line (%d) does not exist.', lineIndex
      )
    )
    self.content[lineIndex] = self.content[lineIndex] .. string
  end
end

---
---Merge the lines of the string buffer into a single string.
---
---@param separator? string
---@return string
---
stringBuffer.merge = function(self, separator)
  return table.concat(self.content, separator or '\n')
end

---
---Apply a function to each line of the string buffer. If the function
---returns a new string, it will replace the original line.
---
---@param callback fun(line: string): string?
---
stringBuffer.process = function(self, callback)
  array.iterate(self.content,
    function(_, line) return callback(line) end
  )
end
