assert(_G.declare == nil,
  'Global variable conflict: `declare` already exists'
)

--
-- Safely defines a global variable.
-- Throws an error if the identifier is already in use.
--
-- @param name (string)   - The global key to register.
-- @param value (unknown) - The value to assign.
--
-- # version: 1.0.0
--
_G.declare = function (name, value)
  assert(_G[name] == nil,
    'Global variable conflict: `'..name..'` already exists'
  )
  _G[name] = value
end