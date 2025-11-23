assert(_G.declare == nil,
  'Global variable conflict: `declare` has already been defined.'
)

--
-- `declare` (global utility function) version 1.0.0
--
-- Assigns a value to a global variable, asserting that the variable does not
-- already exist to prevent accidental overwrites of existing globals.
--

_G.declare = function (variable, value)
  assert(_G[variable] == nil,
    'Global variable conflict: `'..variable..'` has already been defined.'
  )
  _G[variable] = value
end

--
-- `throw` (global utility function) version 1.0.0
--
-- Standardized exception/error function that accepts a format string and arguments
-- (passed to `string.format`). Calls the native Lua `error` function with level 2
-- to point the error source to the calling function, not `throw` itself.
--

declare(
  'throw',
  
  function (exception, ...)
    error(... and string.format(exception, ...) or exception, 2)
  end
)

--
-- `switch` (global utility function) version 1.0.0
--
-- Provides a structured flow control similar to switch statements found in other languages.
-- The passed `value` is matched against keys in the `cases` table. Keys can be a single value,
-- or a table of values for multi-case matching.
--
--   If a match is found, the corresponding `case` content is returned/executed.
--   If the resolved case is a function, it is executed and its result is returned.
--   If no match is found, it falls back to `default` case, if specified.
--

declare(
  'switch',
  
  function (value, cases)
    if value == nil then
      throw 'Expected argument `value` to be non-nil.'
    elseif type(cases) ~= 'table' then
      throw ('Expected `cases` to be a table, got %s', type(cases))
    end

    local case = cases[value]

    if case == nil then
      for key, content in pairs(cases) do
        if type(key) == 'table' then
          for _, target in ipairs(key) do
            if target == value then
              case = content
              break --the value was caught by a multi-case pattern.
            end
          end
        end
        
        if case ~= nil then
          break --stop the iteration.
        end
      end
    end

    if case == nil then
      case = cases.default
    end

    if type(case) == 'function' then
      return case() --the result of the provided action.
    end

    return case --the value.
  end
)

--
-- `when` (global utility function) version 1.0.0
--
-- An expressive utility for ternary-like operations or conditional execution.
--
--   If `condition` is true, `on_true` is selected; otherwise `on_false` is selected.
--   If the chosen result is a function, it's executed and its return value is used.
--

declare(
  'when',
  
  function (condition, on_true, on_false)
    local result = on_false

    if condition == true then
      result = on_true
    end

    if type(result) == 'function' then
      return result() -- return the result of the function.
    end

    return result -- return the value.
  end
)

--
-- `immutable` (global utility function) version 1.0.0
--
-- Creates an immutable (read-only) wrapper around a target table using metatables.
--
--   Any attempts to write to the wrapper will throw an error.
--   Reading nested tables recursively applies `immutable`, ensuring deep immutability.
--

declare(
  'immutable',
  
  function (target)
    if type(target) ~= 'table' then
      throw ('Expected `target` to be a table, got %s', type(target))
    end
    
    return setmetatable({}, {
      __newindex = function ()
        throw 'Blocked attempt to modify a protected table.'
      end,
      __index = function(_, key)
        local value = target[key]
        return (type(value) == 'table' and immutable(value)) or value
      end
    })
  end
)

--
-- `each` (global utility object)
--
-- Utility container for table iteration methods.
--

declare(
  'each',
  {
    --
    -- `pair` (utility method) version 1.0.0
    --
    -- Iterates over a table using `pairs` (key/value), applying a `callback`.
    -- Returns a new table where keys are preserved and values are the callback results.
    --
    
    pair = function (target, callback)
      if type(target) ~= 'table' then
        throw ('Expected `target` to be a table, recieved %s', type(target))
      elseif type(callback) ~= 'function' then
        throw ('Expected `callback` to be a function, recieved %s', type(callback))
      end
      
      local result = {}
      for key, value in pairs(target) do
        result[key] = callback(key, value)
      end
      
      return result
    end,
    
    --
    -- `value` (utility method) version 1.0.0
    --
    -- Iterates over a list table using `ipairs` (index/value), applying a `callback`.
    -- Returns a new list table containing all non-nil results from the callback.
    --
    
    value = function (target, callback)
      if type(target) ~= 'table' then
        throw ('Expected `target` to be a table, recieved %s', type(target))
      elseif type(callback) ~= 'function' then
        throw ('Expected `callback` to be a function, recieved %s', type(callback))
      end
      
      local result = {}
      for index, value in ipairs(target) do
        local callback_result = callback(value, index)
        
        if callback_result ~= nil then
          table.insert(result, callback_result)
        end
      end
      
      return result
    end
  }
)

--
-- `extendable` (global utility function) version 1.0.0
--
-- Augments a table with an `extend` method, allowing safe, non-overwriting
-- addition of key/handler pairs. Throws an error if the key already exists.
--

declare(
  'extendable',
  
  function (target)
    target.extend = function (key, handler)
      if target[key] ~= nil then
        throw ('Object extension failed: the key `%s` already exists', key)
      end
      target[key] = handler
    end
    return target
  end
)

--
-- `map` (global utility object)
--
-- Utility container for table mapping/transformation methods.
--

declare(
  'map',
  {
    --
    -- `keys` (utility method) version 1.0.0
    --
    -- Returns a new list table containing all keys from the `target` table.
    --
    
    keys = function (target)
      if type(target) ~= 'table' then
        throw ('Expected `target` to be a table, recieved %s', type(target))
      end
      
      local keys = {}
      for key in pairs(target) do
        table.insert(keys, key)
      end
      return keys
    end
  }
)

--
-- `printf` (global utility function) version 1.0.0
--
-- Prints a message to the chat window with color code support. It supports:
--
-- 1. Standard `string.format` formatting.
-- 2. Hex color codes: `<#RRGGBB>` (e.g., `<#F5DEB3>text</end>`).
-- 3. Named color codes (e.g., `<error>text</end>`):
--    normal, neutral, faded, info, error, warning, success
-- 4. Color reset: `</end>`.
--

declare(
  'printf',
  
  function (message, ...)
    local palette = {
      normal  = 'F5DEB3', -- Warm, wheat color.
      neutral = 'FFFFFF', -- Plain white.
      faded   = 'BEBEBE', -- Light gray.
      info    = '4682B4', -- Steel blue.
      error   = 'CC4733', -- Dark red-orange.
      warning = 'FCD462', -- Soft golden-yellow.
      success = '00AC00', -- Bright green.
    }
    message = (
        ... and string.format(message, ...) or message
      )
      :gsub('<#(%x%x%x%x%x%x)>',
        function(hex_color) return '|cFF' .. hex_color end
      )
      :gsub('<([^/>]+)>',
        function(color_code)
          return switch(
            color_code,
            {
              default = function()
                return '<' .. color_code .. '>'
              end,
              [map.keys(palette)] = function()
                return '|cFF' .. palette[color_code]
              end
            }
          )
        end
      )
      :gsub('</end>', '|r')

    print(message)
  end
)