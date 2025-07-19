--[[~ Updated: 2025/07/19 | Author(s): Gopher ]]
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
---Processes a raw command string, parsing arguments and preparing a payload for a command handler.
---
---@param message string
---@param callback backbone.command-handler
---
local processCommand = function(message, callback)
  local arguments = {}
  local payload = { message = message, arguments = arguments }

  local parser_state =
  {
    current_value = '',
    is_quoted_value = false,
    is_item_link = false
  }

  local clearParserState = function()
    parser_state.current_value = ''
    parser_state.is_quoted_value = false
    parser_state.is_item_link = false
  end

  local appendCommandArgument = function()
    table.insert(arguments, parser_state.current_value)
    clearParserState()
  end

  for i = 1, #message do
    local continue = false
    local current_character = string.sub(message, i, i)

    if current_character == ' ' and not parser_state.is_item_link then
      appendCommandArgument()
      continue = true
    end

    if not continue and current_character == '"' then
      local previous_character = string.sub(message, i - 1, i - 1)

      if previous_character ~= '\\' then
        parser_state.is_quoted_value = not parser_state.is_quoted_value
        continue = true
      end
    end

    if not continue and not parser_state.is_quoted_value and
        (current_character == '[' or current_character == ']') then
      parser_state.is_item_link = not parser_state.is_item_link
    end

    if not continue then
      parser_state.current_value = parser_state.current_value .. current_character
    end

    if i == #message then
      appendCommandArgument()
    end
  end

  backbone.queueTask(function() callback(payload) end)
end

---
---Registers a new chat command that can be used in-game.
---
---An error will be thrown if a command with the given `name` is already registered.
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
