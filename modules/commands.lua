--[[~ Updated: 2025/04/19 | Author(s): Gopher ]]
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
  local arguments = {}
  local payload = { message = message, arguments = arguments }

  backbone.printf('Processing command: %s', message)

  local parserState =
  {
    currentValue = '',
    isQuotedValue = false,
    isItemLink = false
  }

  local clearParserState = function()
    parserState.currentValue = ''
    parserState.isQuotedValue = false
    parserState.isItemLink = false
  end

  local appendCommandArgument = function()
    table.insert(arguments, parserState.currentValue)
    clearParserState()
  end

  for i = 1, #message do
    local continue = false
    local currentCharacter = string.sub(message, i, i)

    if currentCharacter == ' ' and not parserState.isItemLink then
      appendCommandArgument()
      continue = true
    end

    if not continue and currentCharacter == '"' then
      local previousCharacter = string.sub(message, i - 1, i - 1)

      if previousCharacter ~= '\\' then
        parserState.isQuotedValue = not parserState.isQuotedValue
        continue = true
      end
    end

    if not continue and not parserState.isQuotedValue and
        (currentCharacter == '[' or currentCharacter == ']') then
      parserState.isItemLink = not parserState.isItemLink
    end

    if not continue then
      parserState.currentValue = parserState.currentValue .. currentCharacter
    end

    if i == #message then
      appendCommandArgument()
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
