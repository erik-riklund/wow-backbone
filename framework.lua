---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/01 | Author(s): Gopher ]]
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
backbone =
{
  ---
  ---Provides utility functions for common tasks.
  ---
  utils = {}
}

--=============================================================================
-- OUTPUT HANDLING:
--
-- This module provides utility functions for logging and displaying output
-- in the default chat frame. It includes tools for printing strings, numbers,
-- and complex data structures like tables in a readable format.
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
  elseif value_type == 'nil' then
    print 'nil'
  else
    print(
      string.format('%s: %s', value_type, tostring(value))
    )
  end
end

--=============================================================================
-- ENVIRONMENT:
--
-- This module manages the framework's runtime environment, allowing developers
-- to differentiate between "development" and "production" modes. It provides
-- functionality to query and set the current environment state.
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
--
-- This module provides a collection of utility functions for working with arrays,
-- dictionaries, strings, and tables. These functions help streamline common tasks.
--=============================================================================

---
---Utility methods for working with arrays.
---
---@class backbone.utils.array
---
backbone.utils.array =
{
  ---
  ---Determine if the provided table is an array.
  ---
  ---@param target table
  ---@return boolean
  ---
  is = function(target)
    for key in pairs(target) do
      if type(key) ~= 'number' then return false end
    end
    return true
  end,

  ---
  ---Determine if the table contains an element at the specified position.
  ---
  ---@param target unknown[]
  ---@param position number
  ---@return boolean
  ---
  has = function(target, position)
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
  ---@param target V[]
  ---@param value V
  ---@param position? number
  ---@return V
  ---
  insert = function(target, value, position)
    assert(
      value ~= nil,
      'Expected argument `value` to be non-nil.'
    )

    local max_index = #target + 1
    position = position or max_index
    assert(
      position > 0 and position <= max_index,
      'Index "' .. position .. '" is out of range.'
    )

    table.insert(target, position, value)
    return target[position]
  end,

  ---
  ---Remove an element from the table. If no position is specified,
  ---the last element is removed.
  ---
  ---@generic V
  ---@param target V[]
  ---@param position? number
  ---@return V
  ---
  remove = function(target, position)
    local value = table.remove(target, position)
    assert(
      value ~= nil,
      'There is no element at the position "' .. position .. '".'
    )
    return value
  end,

  ---
  ---Apply a function to each element of the array. If the function
  ---returns a value, the element is replaced with the returned value.
  ---
  ---@generic V
  ---@param target V[]
  ---@param callback fun(index: number, value: V): unknown?
  ---
  foreach = function(target, callback)
    assert(
      type(callback) == 'function',
      'Expected argument `callback` to be a function.'
    )

    for index, value in ipairs(target) do
      local result = callback(index, value)
      if result ~= nil then
        target[index] = result
      end
    end
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
  has = function(target, key)
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
  get = function(target, key)
    assert(
      target[key] ~= nil,
      'There is no entry with the key "' .. tostring(key) .. '".'
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
  set = function(target, key, value)
    assert(
      value ~= nil,
      'Expected argument `value` to be non-nil.'
    )
    target[key] = value
    return target[key]
  end,

  ---
  ---Remove an entry from the table and return its value.
  ---
  ---@generic K, V
  ---@param target table<K, V>
  ---@param key K
  ---@return V
  ---
  drop = function(target, key)
    local value = target[key]
    assert(
      value ~= nil,
      'There is no entry with the key "' .. key .. '".'
    )
    target[key] = nil
    return value
  end,

  ---
  ---Apply a function to each entry of the dictionary. If the function
  ---returns a value, the entry is replaced with the returned value.
  ---
  ---@generic K, V
  ---@param target table<K, V>
  ---@param callback fun(key: K, value: V): unknown?
  ---
  foreach = function(target, callback)
    assert(
      type(callback) == 'function',
      'Expected argument `callback` to be a function.'
    )

    for key, value in pairs(target) do
      local result = callback(key, value)
      if result ~= nil then
        target[key] = result
      end
    end
  end
}

local dictionary = backbone.utils.dictionary

---
---Utility functions for working with tables.
---
backbone.utils.table =
{
  ---
  ---Protect a table from modification by wrapping it in a read-only proxy.
  ---
  ---@generic T:table
  ---@param target T
  ---@return T
  ---
  protect = function(target)
    assert(
      type(target) == 'table',
      'Expected argument `target` to be a table.'
    )

    local blocker = function()
      error('Cannot modify a protected table.', 2)
    end
    local retriever = function(_, key)
      local protect = backbone.utils.table.protect
      return (type(target[key]) == 'table' and protect(target[key])) or target[key]
    end

    return setmetatable({}, {
      __index = retriever, __newindex = blocker
    })
  end,

  ---
  ---?
  ---
  ---@param target table
  ---@param steps string[]
  ---@param mode? 'exit'|'build'
  ---@return unknown
  ---
  traverse = function(target, steps, mode)
    mode = mode or 'exit'
    assert(
      mode == 'exit' or mode == 'build',
      'Expected argument `mode` to be "exit" or "build".'
    )

    local value = target
    local step_count = #steps
    for index, key in ipairs(steps) do
      if value[key] == nil then
        if mode == 'exit' then return nil end
        value[key] = {} -- create missing steps in 'build' mode.
      end
      
      value = value[key]
      assert(
        type(value) ~= 'table' and index < step_count,
        'Unexpected non-table value at step "' .. key .. '".'
      )
    end

    return value
  end
}

--=============================================================================
-- ADDON MANAGER:
--
-- This module manages the registration and retrieval of addons within the Backbone
-- ecosystem. It ensures each addon is uniquely identified and provides utilities
-- for accessing and verifying registered addons.
--=============================================================================

local addons = ({} --[[@as table<string, backbone.addon>]])
context.addon_initializers = ({} --[[@as table<number, fun(addon: backbone.addon)>]])
local getAddonId = function(name) return string.lower(name) end

---
---Represents a unique addon within the Backbone ecosystem.
---
---@class backbone.addon
---
context.__addon = {}

---
---Create and return a new addon object with the specified name.
---
---@param name string
---@return backbone.addon
---
backbone.registerAddon = function(name)
  local addon_id = getAddonId(name)
  assert(
    not dictionary.has(addons, addon_id),
    'An addon with the name "' .. name .. '" already exists.'
  )

  ---@class backbone.addon
  local addon = {
    getId = function(self) return addon_id end,
    getName = function(self) return name end
  }
  return dictionary.set(addons, addon_id,
    setmetatable(addon, { __index = context.__addon })
  )
end

---
---Determine if an addon with the specified name has been registered.
---
---@param name string
---@return boolean
---
backbone.hasAddon = function(name)
  return dictionary.has(addons, getAddonId(name))
end

---
---The addon object that represents the framework itself.
---
context.addon = backbone.registerAddon 'Backbone'

---
---Retrieve an addon object by its name.
---
---@param name string
---@return backbone.addon
---
context.getAddon = function(name)
  local addon_id = getAddonId(name)
  assert(
    dictionary.has(addons, addon_id),
    'There is no registered addon with the name "' .. name .. '".'
  )
  return dictionary.get(addons, addon_id)
end

--=============================================================================
-- TASK EXECUTION:
--
-- This module provides functionality for managing and executing tasks within
-- the framework. It supports immediate and queued task execution, ensuring
-- that tasks are processed efficiently and non-blockingly during frame updates.
--=============================================================================

local tasks = ({} --[[@as table<number, fun()>]])
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
  array.insert(tasks, task)
end

---
---Responsible for handling the execution of queued tasks.
---Ensures that the tasks are executed in a non-blocking manner.
---
taskFrame:SetScript(
  'OnUpdate', function()
    if tasks[1] ~= nil then
      local time_limit = 0.01667 -- 60 fps
      local time_started = GetTimePreciseSec()

      while tasks[1] ~= nil and (GetTimePreciseSec() - time_started < time_limit) do
        backbone.executeTask(table.remove(tasks, 1))
      end
    end
  end
)
