--
-- Checks if at least one provided argument is true.
-- Performs a logical OR across a variable number of conditions.
--
-- @param ... (boolean) - The conditions to evaluate.
--
-- # version: 1.0.0
--
declare(
  'any', function (...)
    local conditions = {...}
    
    for _, condition in ipairs(conditions) do
      if condition == true then return true end
    end
    
    return false
  end
)