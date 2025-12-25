--
-- Executes a conditional branch based on a value.
-- Matches against keys or lists of keys, falling back to a default case.
--
-- @param value (unknown) - The value to match.
-- @param cases (table)   - A map of values or tables of values to results.
--
-- # version: 1.0.0
--
declare(
  'switch', function (value, cases)
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