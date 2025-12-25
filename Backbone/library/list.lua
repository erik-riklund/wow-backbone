--
-- A collection of utilities for sequential arrays.
--
declare(
  'list',
  {
    --
    -- Checks if any element in the array satisfies the callback condition.
    -- Short-circuits and returns true on the first truthy match.
    --
    -- @param target (table)      - The array to search.
    -- @param callback (function) - A predicate function receiving (value, index).
    --
    -- # version: 1.0.0
    --
    any = function (target, callback)
      if type(target) ~= 'table' then
        throw ('Expected `target` to be a table, recieved %s', type(target))
      elseif type(callback) ~= 'function' then
        throw ('Expected `callback` to be a function, recieved %s', type(callback))
      end
      
      for index, value in ipairs(target) do
        local callback_result = callback(value, index)
        if callback_result == true then return true end
      end
      return false
    end,
    
    --
    -- Iterates over an array and maps values to a new sequential table.
    -- Filters out nil results from the callback.
    --
    -- @param target (table)     - The array to iterate over.
    -- @param callback (function) - A function receiving (value, index).
    --
    -- # version: 1.0.0
    --
    each = function (target, callback)
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