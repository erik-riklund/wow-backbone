--[[~ Updated: 2025/01/21 | Author(s): Gopher ]]
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
---@param message string
---@param callback backbone.command-handler
---
local processCommand = function(message, callback)
  local payload = { message = message }
  local arguments = payload.arguments

  local parser =
  {
    isArgument = false,
    isValue = false,
    isQuotedValue = false,
    currentArgument = '',
    currentValue = ''
  }

  local resetParser = function()
    parser.isArgument = false
    parser.isValue = false
    parser.currentArgument = ''
    parser.currentValue = ''
  end

  local handleDash = function()
    if not parser.isQuotedValue then
      parser.isArgument = true
    else
      parser.currentValue = parser.currentValue .. '-'
    end
  end

  local handleEquals = function()
    if not parser.isQuotedValue then
      parser.isArgument = false
      parser.isValue = true
      parser.currentValue = ''
    else
      parser.currentValue = parser.currentValue .. '='
    end
  end

  local handleSpace = function()
    if not parser.isQuotedValue then
      if parser.currentArgument ~= '' then
        arguments[parser.currentArgument] = parser.currentValue
      end
      resetParser()
    else
      parser.currentValue = parser.currentValue .. ' '
    end
  end

  local handleDoubleQuote = function()
    parser.isQuotedValue = not parser.isQuotedValue
  end

  local handleCharacter = function(character)
    if parser.isArgument then
      parser.currentArgument = parser.currentArgument .. character
    elseif parser.isValue then
      parser.currentValue = parser.currentValue .. character
    end
  end

  for n = 1, #message do
    local character = string.sub(message, n, n)

    if character == '-' then
      handleDash()
    elseif character == '=' then
      handleEquals()
    elseif character == ' ' then
      handleSpace()
    elseif character == '"' then
      handleDoubleQuote()
    else
      handleCharacter(character)
    end

    if n == #message and parser.currentArgument ~= '' then
      arguments[parser.currentArgument] = parser.currentValue
    end
  end

  backbone.queueTask(function() callback(payload) end)
end

---
---@param name string
---@param callback backbone.command-handler
---
backbone.registerCommand = function(name, callback)
  local variable = 'SLASH_' .. name .. '1'
  if _G[variable] ~= nil then
    throw('There is already a command with the name `%s`.', name)
  end
  _G[variable] = '/' .. name
  _G['SlashCmdList'][name] = function(message)
    processCommand(message, callback)
  end
end
