--
-- Injects an extension method into a table.
-- Allows the table to be safely expanded with new members via a protected interface.
--
-- @param target (table) - The table to make extendable.
--
-- # version: 1.0.0
--
declare(
  'extendable', function (target)
    if type(target) ~= 'table' then
      throw ('Expected `target` to be a table, got %s', type(target))
    elseif target.extend ~= nil then
      throw 'Object extension failed: the key `extend` already exists'
    end
    
    target.extend = function (key, handler)
      if target[key] ~= nil then
        throw ('Object extension failed: the key `%s` already exists', key)
      end
      target[key] = handler
    end
    
    return target
  end
)