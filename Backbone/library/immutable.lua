--
-- Wraps a table in a read-only proxy.
-- Recursively protects nested tables and prevents any modifications.
--
-- @param target (table) - The table to make immutable.
--
-- # version: 1.0.0
--
declare(
  'immutable', function (target)
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