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
  'Global variable conflict: `bufferString` has already been defined.'
)

---
---
---
---@class backbone.string-buffer
---@field protected content string[]
---
_G.stringBuffer = {}

---
---
---
---@return backbone.string-buffer
---
stringBuffer.new = function(self)
  return inherit(self, { content = {} })
end

---
---
---
---@param string string
---
stringBuffer.appendLine = function(self, string)
  array.append(self.content, string)
end

---
---
---
---@param string string
---
stringBuffer.append = function(self, string)
  if self.content[1] == nil then
    array.append(self.content, string)
  else
    local lastLineIndex = #self.content
    self.content[lastLineIndex] = self.content[lastLineIndex] .. string
  end
end

---
---
---
---@param separator? string
---@return string
---
stringBuffer.merge = function(self, separator)
  return table.concat(self.content, separator or '\n')
end

---
---
---
---@param callback fun(line: string): string?
---
stringBuffer.process = function(self, callback)
  array.iterate(self.content,
    function(_, line) return callback(line) end
  )
end


