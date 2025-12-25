--
-- A collection of iterator utilities for table transformation.
--
declare(
  'each',
  {
    --
    -- Iterates over a table and maps keys to new values.
    -- Processes all entries using the standard `pairs` iterator.
    --
    -- @param target (table)      - The table to iterate over.
    -- @param callback (function) - A function returning the new value for each key.
    -- @returns table - A new table with the resulting key-value pairs.
    --
    -- # version: 1.0.0
    --
    pair = function (target, callback)
      if type(target) ~= 'table' then
        throw ('Expected `target` to be a table, got %s', type(target))
      elseif type(callback) ~= 'function' then
        throw ('Expected `callback` to be a function, got %s', type(callback))
      end
      
      local result = {}
      for key, value in pairs(target) do
        result[key] = callback(key, value)
      end
      
      return result
    end,
    
    --
    -- Iterates over an array and maps values to a new sequential table.
    -- Filters out nil results from the callback.
    --
    -- @param target (table)     - The array to iterate over.
    -- @param callback (function) - A function receiving (value, index).
    -- @returns table - A new array with the resulting values.
    --
    -- # version: 1.0.0
    --
    value = function (target, callback)
      if type(target) ~= 'table' then
        throw ('Expected `target` to be a table, got %s', type(target))
      elseif type(callback) ~= 'function' then
        throw ('Expected `callback` to be a function, got %s', type(callback))
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