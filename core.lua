---@class __backbone
local context = select(2, ...)

---@diagnostic disable: invisible

--[[~ Updated: 2025/01/04 | Author(s): Gopher ]]
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
  ---A string representation of the current locale.
  ---
  ---@type backbone.locale
  ---
  activeLocale = GetLocale(),

  ---
  ---A numerical value representing the current expansion level.
  ---
  ---@type number
  ---
  currentExpansion = GetExpansionLevel()
}

---
---The palette of colors used by the framework.
---
local palette =
{
  normal    = 'F5DEB3', -- Warm, wheat color.
  neutral   = 'BEBEBE', -- Neutral light gray.
  info      = '4682B4', -- Steel blue.
  error     = 'CC4733', -- Dark red-orange.
  highlight = 'FCD462', -- Soft golden-yellow.
  success   = '6B8E23', -- Dark olive green.
}

---
---Print the provided message to the default chat frame.
---
---@param output unknown
---
backbone.print = function(output)
  backbone.utils.logic.switch(
    type(output),
    {
      string = function()
        print(backbone.utils.string.colorize(output))
      end,
      default = function() backbone.dump(output) end
    }
  )
end

---
---Format and print the provided message to the default chat frame.
---
---@param output string
---@param ... string
---
backbone.printf = function(output, ...)
  backbone.print(string.format(output, ...))
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
---Provides utility functions for common tasks.
---
---@class backbone.utils
---
backbone.utils =
{
  ---
  ---Utility methods for working with arrays.
  ---
  ---@class backbone.utils.array
  ---
  array =
  {
    ---
    ---Determine if the provided table is an array.
    ---
    ---@param target table
    ---@return boolean
    ---
    is = function(target)
      local elements = 0
      for _ in pairs(target) do
        elements = elements + 1
      end
      return (elements == #target)
    end,

    ---
    ---Determine if the array contains an element at the specified position.
    ---
    ---@param target unknown[]
    ---@param position number
    ---@return boolean
    ---
    has = function(target, position)
      assert(
        type(position) == 'number', string.format(
          'Expected argument `position` to be a number, received %s.', type(position)
        )
      )
      return target[position] ~= nil
    end,

    ---
    ---Determine if the array contains the specified value.
    ---
    ---@generic V
    ---@param target V[]
    ---@param value V
    ---@return boolean
    ---
    contains = function(target, value)
      for _, element in ipairs(target) do
        if element == value then return true end
      end
      return false
    end,

    ---
    ---Insert a value into the array. If no position is specified,
    ---the value is inserted at the end of the array.
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
        position > 0 and position <= max_index, string.format(
          'Expected argument `position` to be between 1 and %d, received %d.', max_index, position
        )
      )

      table.insert(target, position, value)
      return value
    end,

    ---
    ---Remove an element from the array. If no position is specified,
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
        value ~= nil, string.format(
          'Expected argument `position` to be between 1 and %d, received %d.', #target, position
        )
      )
      return value
    end,

    ---
    ---Clear all elements from the array.
    ---
    ---@generic T:table
    ---@param target T
    ---@return T
    ---
    clear = function(target) return wipe(target) end,

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
        type(callback) == 'function', string.format(
          'Expected argument `callback` to be a function, received %s.', type(callback)
        )
      )

      for index, value in ipairs(target) do
        local result = callback(index, value)
        if result ~= nil then
          target[index] = result
        end
      end
    end
  },

  ---
  ---Utility methods for working with dictionaries.
  ---
  ---@class backbone.utils.dictionary
  ---
  dictionary =
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
    drop = function(target, key)
      local value = target[key]
      assert(
        value ~= nil, string.format(
          'The table does not contain an entry with the key "%s".', key
        )
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
        type(callback) == 'function', string.format(
          'Expected argument `callback` to be a function, received %s.', type(callback)
        )
      )

      for key, value in pairs(target) do
        local result = callback(key, value)
        if result ~= nil then
          target[key] = result
        end
      end
    end,

    ---
    ---Combine multiple dictionaries into a single one. The target dictionary is altered
    ---and returned for further modification. Existing values will not be overwritten.
    ---
    ---@generic K, V
    ---@param target table<K, V>
    ---@param ... table<K, V>
    ---@return table<K, V>
    ---
    combine = function(target, ...)
      local sources = { ... }
      for _, source in ipairs(sources) do
        for key, value in pairs(source) do
          if target[key] == nil then target[key] = value end
        end
      end
      return target
    end
  },

  ---
  ---?
  ---
  ---@class backbone.utils.logic
  ---
  logic =
  {
    ---
    ---?
    ---
    ---@generic V
    ---@param value V
    ---@param cases table<'default'|V|V[], unknown|(fun(): unknown?)>
    ---@return unknown?
    ---
    switch = function(value, cases)
      local case = cases[value]

      if case == nil then
        for key, content in pairs(cases) do
          if type(key) == 'table' then
            for _, target in ipairs(key) do
              if target == value then
                case = content
                break -- the value was caught by a multi-case pattern.
              end
            end
          end
        end
      end

      if case == nil then case = cases['default'] end
      return (type(case) == 'function' and case()) or case
    end
  },

  ---
  ---Utility methods for working with strings.
  ---
  ---@class backbone.utils.string
  ---
  string =
  {
    ---
    ---?
    ---
    ---@class backbone.utils.string-builder
    ---@field private lines string[]
    ---
    builder =
    {
      ---
      ---?
      ---
      ---@param self backbone.utils.string-builder
      ---@return backbone.utils.string-builder
      ---
      new = function(self)
        local instance = setmetatable({ lines = {} }, { __index = self })
        return instance --[[@as backbone.utils.string-builder]]
      end,

      ---
      ---?
      ---
      ---@param self backbone.utils.string-builder
      ---@param content string
      ---
      append = function(self, content)
        if self.lines[1] == nil then
          self.lines[1] = content
        else
          local line_count = #self.lines
          self.lines[line_count] = self.lines[line_count] .. content
        end
      end,

      ---
      ---?
      ---
      ---@param self backbone.utils.string-builder
      ---@param content string
      ---
      appendLine = function(self, content)
        table.insert(self.lines, content)
      end,

      ---
      ---?
      ---
      ---@param self backbone.utils.string-builder
      ---@param separator? string
      ---@return string
      ---
      toString = function(self, separator)
        return table.concat(self.lines, separator or '\n')
      end,

      ---
      ---?
      ---
      ---@param self backbone.utils.string-builder
      ---@param callback fun(line: string)
      ---
      finalize = function(self, callback)
        backbone.utils.array.foreach(self.lines,
          function(_, line) callback(line) end
        )
      end
    },

    ---
    ---?
    ---
    ---@param target string
    ---@return string
    ---
    colorize = function(target)
      target = target
          :gsub('<color:[ ]*#([^>]+)>',
            function(color) return '|cFF' .. color end
          )
          :gsub('<([^/>]+)>',
            function(type)
              local array = backbone.utils.array

              local color_types = { 'normal', 'error', 'highlight', 'success', 'neutral', 'info' }
              return (array.contains(color_types, type) and ('|cFF' .. palette[type])) or ('<' .. type .. '>')
            end
          )
          :gsub('</end>', '|r')

      return target
    end
  },

  ---
  ---Utility functions for working with tables.
  ---
  ---@class backbone.utils.table
  ---
  table =
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
        type(target) == 'table', string.format(
          'Expected argument `target` to be a table, received %s.', type(target)
        )
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
    ---Traverse a table using the specified steps. In 'build' mode, missing
    ---steps are created, while the traversal is cancelled in 'exit' mode.
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
      for _, key in ipairs(steps) do
        if value[key] == nil then
          if mode == 'exit' then return nil end
          value[key] = {} -- create missing steps in 'build' mode.
        end
        value = value[key]
      end

      return value
    end
  }
}

local array = backbone.utils.array
local dictionary = backbone.utils.dictionary

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
    not dictionary.has(addons, addon_id), string.format(
      'An addon with the name "%s" already exists.', name
    )
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
---Determine if an addon with the specified name has been registered with the framework.
---
---@param name string
---@return boolean
---
backbone.hasRegisteredAddon = function(name)
  return dictionary.has(addons, getAddonId(name))
end

---
---Determine if an addon (not only those registered with the framework) is loaded.
---
---@param name string
---@return boolean
---
backbone.isAddonLoaded = function(name)
  return select(2, C_AddOns.IsAddOnLoaded(name))
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
    dictionary.has(addons, addon_id), string.format(
      'The requested addon "%s" does not exist.', name
    )
  )
  return addons[addon_id]
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
    local file, line, message = string.split(':', result, 3)
    backbone.print('<error>[Backbone]' .. message .. '</end>')

    if environment == 'development' then
      local folders = { string.split('/', file) }
      if folders[3] ~= 'Backbone' then
        backbone.print(string.format('%s (line %d)', file, line))
      end
    end
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
