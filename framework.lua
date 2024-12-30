---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2024/12/30 | Author(s): Gopher ]]
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
---The API for the Backbone framework.
---
backbone = { utils = {} }

--=============================================================================
-- OUTPUT HANDLING:
-- <add description of the module>
--=============================================================================

---
---Print the provided message to the default chat frame.
---
---@param ... unknown
---
backbone.print = function(...)
  local values = { ... }
  for i = 1, #values, 1 do
    local value = values[i]
    if type(value) == 'string' then
      print(value)
    else
      backbone.dump(value)
    end
  end
end

---
---Print the provided value to the default chat frame. If the value
---is a table, its contents will be printed as a flat list.
---
---@param value unknown
---
backbone.dump = function(value)
  local value_type = type(value)
  if value_type == 'table' then
    print 'table: {'
    for key, content in pairs(value) do
      if type(content) == 'string' then
        content = '"' .. content .. '"'
      end
      print(
        string.format('  %s = %s', tostring(key), tostring(content))
      )
    end
    print '}'
  elseif value_type == 'string' then
    print(
      string.format('string: "%s"', value)
    )
  else
    print(
      string.format('%s: %s', value_type, tostring(value))
    )
  end
end

--=============================================================================
-- ENVIRONMENT:
-- <add description of the module>
--=============================================================================

---
---The current environment of the framework.
---
local environment = 'development'

---
---Obtain a string representation of the current environment.
---
---@return 'development'|'production'
---
backbone.getEnvironment = function()
  return environment
end

---
---Set the current environment to the specified mode.
---
---@param mode 'development'|'production'
---
backbone.setEnvironment = function(mode)
  assert(
    environment == 'development' or environment == 'production',
    'Expected argument `environment` to be either "development" or "production".'
  )
  environment = mode
end

--=============================================================================
-- UTILITIES:
-- <add description of the module>
--=============================================================================

---
---Utility methods for working with arrays.
---
backbone.utils.array =
{
  ---
  ---Determine if the table contains an element at the specified position.
  ---
  ---@param target array<unknown>
  ---@param position number
  ---@return boolean
  ---
  hasElement = function(target, position)
    assert(
      type(position) == 'number',
      'Expected argument `position` to be a number.'
    )
    return target[position] ~= nil
  end,

  ---
  ---Insert a value into the table. If no position is specified,
  ---the value is inserted at the end of the table.
  ---
  ---@generic V
  ---@param target array<V>
  ---@param value V
  ---@param position? number
  ---@return V
  ---
  insertElement = function(target, value, position)
    assert(
      value ~= nil,
      'Expected argument `value` to be non-nil.'
    )

    local maxIndex = #target + 1
    position = position or maxIndex
    assert(
      position > 0 and position <= maxIndex,
      'Index "' .. position .. '" is out of range.'
    )

    table.insert(target, position, value)
    return value
  end,

  ---
  ---Remove an element from the table. If no position is specified,
  ---the last element is removed.
  ---
  ---@generic V
  ---@param target array<V>
  ---@param position? number
  ---@return V
  ---
  removeElement = function(target, position)
    local value = table.remove(target, position)
    assert(
      value ~= nil,
      'There is no element at the position "' .. position .. '".'
    )
    return value
  end
}

local array = backbone.utils.array

---
---Utility methods for working with dictionaries.
---
backbone.utils.dictionary =
{
  ---
  ---Determine if the table contains an entry with the specified key.
  ---
  ---@generic K
  ---@param target table<K, unknown>
  ---@param key K
  ---@return boolean
  ---
  hasEntry = function(target, key)
    return target[key] ~= nil
  end,

  ---
  ---Retrieve the value of an entry in the table.
  ---Throws an error if the entry does not exist.
  ---
  ---@generic K, V
  ---@param target table<K, V>
  ---@param key K
  ---@return V
  ---
  getEntry = function(target, key)
    assert(
      target[key] ~= nil,
      'There is no entry with the key "' .. key .. '".'
    )
    return target[key]
  end,

  ---
  ---Set the value of an entry in the table.
  ---
  ---@generic K, V
  ---@param target table<K, V>
  ---@param key K
  ---@param value V
  ---@return V
  ---
  setEntry = function(target, key, value)
    assert(
      value ~= nil,
      'Expected argument `value` to be non-nil.'
    )
    target[key] = value
    return value
  end,

  ---
  ---Remove an entry from the table and return its value.
  ---
  ---@generic K, V
  ---@param target table<K, V>
  ---@param key K
  ---@return V
  ---
  dropEntry = function(target, key)
    local value = target[key]
    assert(
      value ~= nil,
      'There is no entry with the key "' .. key .. '".'
    )
    target[key] = nil
    return value
  end
}

local dictionary = backbone.utils.dictionary

--=============================================================================
-- ADDON MANAGER:
-- <add description of the module>
--=============================================================================

local addons = ({} --[[@as table<string, backbone.addon>]])
context.addon_initializers = ({} --[[@as array<fun(addon: backbone.addon)>]])
local getAddonId = function(name) return string.lower(name) end

---
---Represents a unique addon within the Backbone ecosystem.
---
---@class backbone.addon
---
context.__addon = {}

---
---Create and return a new addon object. Throws an error
---if an addon with the specified name already exists.
---
---@param name string
---@return backbone.addon
---
backbone.registerAddon = function(name)
  local addon_id = getAddonId(name)
  assert(
    not dictionary.hasEntry(addons, addon_id),
    'An addon with the name "' .. name .. '" already exists.'
  )
  return dictionary.setEntry(addons, addon_id,
    setmetatable({ id = addon_id, name = name }, { __index = context.__addon })
  )
end

---
---The addon object that represents the framework itself.
---
context.addon = backbone.registerAddon 'Backbone'

---
---Retrieve an addon object by its name.
---Throws an error if the addon does not exist.
---
---@param name string
---@return backbone.addon
---
backbone.getAddon = function(name)
  local addon_id = getAddonId(name)
  assert(
    dictionary.hasEntry(addons, addon_id),
    'There is no registered addon with the name "' .. name .. '".'
  )
  return dictionary.getEntry(addons, addon_id)
end

--=============================================================================
-- TASK EXECUTION:
-- <add description of the module>
--=============================================================================

local tasks = ({} --[[@as array<fun()>]])
local taskFrame = CreateFrame 'Frame' --[[@as Frame]]

---
---Invoke the provided callback in safe mode, gracefully handling any errors.
---
---@param task fun()
---
backbone.executeTask = function(task)
  local success, result = pcall(task)
  if not success and environment == 'development' then
    backbone.print('[Backbone] Error: ' .. result)
  end
end

---
---Queues the provided callback for execution in the next frame.
---Useful for tasks that does not require immediate execution.
---
---@param task fun()
---
backbone.queueTask = function(task)
  array.insertElement(tasks, task)
end

---
---Responsible for handling the execution of queued tasks.
---Ensures that the tasks are executed in a non-blocking manner.
---
taskFrame:SetScript(
  'OnUpdate', function()
    local time_limit = 0.01667 -- 60 fps

    if tasks[1] ~= nil then
      local time_started = GetTimePreciseSec()
      while tasks[1] ~= nil and (GetTimePreciseSec() - time_started < time_limit) do
        backbone.executeTask(array.removeElement(tasks, 1))
      end
    end
  end
)

--=============================================================================
-- ADDON LOADER:
-- <add description of the module>
--=============================================================================


