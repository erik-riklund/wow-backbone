--
-- Evaluates a condition and returns or executes the corresponding branch.
-- Supports both direct values and functions for lazy evaluation.
--
-- @param condition (boolean) - The logical state to check.
-- @param on_true (unknown)   - Value or function to return if true.
-- @param on_false (unknown)  - Value or function to return if false.
--
-- # version: 1.0.0
--
declare(
  'when', function (condition, on_true, on_false)
    local result = on_false

    if condition == true then
      result = on_true
    end

    if type(result) == 'function' then
      return result() -- the result of the function.
    end

    return result -- the value.
  end
)