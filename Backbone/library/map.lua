--
-- A collection of table mapping and extraction utilities.
--
declare(
  'map',
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
    each = function (target, callback)
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
    -- Extracts all keys from a table into a sequential array.
    --
    -- @param target (table) - The table to extract keys from.
    --
    -- # version: 1.0.0
    --
    keys = function (target)
      if type(target) ~= 'table' then
        throw ('Expected `target` to be a table, got %s', type(target))
      end
      
      local keys = {}
      for key in pairs(target) do
        table.insert(keys, key)
      end
      return keys
    end
  }
)