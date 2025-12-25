--
-- [ Custom events handler ]
--
-- Provides a publish/subscribe mechanism, enabling communication between different modules or addons.
--

local events = {
  -- event_id -> list of callbacks
}

--
-- Checks if a specific event has been initialized in the registry.
--
-- @param event (string) - The name of the event to check.
--
-- # version: 1.0.0
--
local eventExists = function (event)
  return events[string.upper(event)] ~= nil
end

--
-- Initializes a new event entry in the local registry.
--
-- @param name (string) - The name of the event to create.
--
-- # version: 1.0.0
--
local createEvent = function (name)
  events[string.upper(name)] = {}
end

--
-- Attaches a callback to an event and returns a cleanup function.
--
-- @param event (string)      - The target event name.
-- @param callback (function) - The function to execute when the event fires.
--
-- # version: 1.0.0
--
local registerEventListener = function (event, callback)
  local event_id = string.upper(event)
  events[event_id] = events[event_id] or {}
  table.insert(events[event_id], callback)
  
  return function ()
    events[event_id] = list.each(
      events[event_id], function (listener)
        return when(listener ~= callback, listener, nil)
      end
    )
  end
end

--
-- Triggers all registered callbacks for a specific event.
--
-- @param event (string) - The name of the event to broadcast.
-- @param ... (unknown)  - Arguments to pass to the listeners.
--
-- # version: 1.0.0
--
local emitEvent = function (event, ...)
  local args = {...}
  
  list.each(events[string.upper(event)] or {},
    function (callback)
      Backbone.ExecuteCallback(
        function() callback(unpack(args)) end
      )
    end
  )
end

--
-- Registers a new unique event and returns its trigger function.
-- Throws an error if the event name is already taken.
--
-- @param name (string) - The unique identifier for the event.
--
-- # version: 1.0.0
--
Backbone.extend(
  'CreateEvent', function (name)
    if eventExists(name) then
      throw ('Failed to create event: "%s" already exists', name)
    end
    
    createEvent(name)
    return function (...)
      emitEvent(name, ...)
    end
  end
)

--
-- Subscribes a callback to a custom event.
-- Throws an error if the event has not been created yet.
--
-- @param event (string)      - The name of the event to listen for.
-- @param callback (function) - The function to call upon emission.
--
-- # version: 1.0.0
--
Backbone.extend(
  'OnCustomEvent', function (event, callback)
    if not eventExists(event) then
      throw ('Failed to register listener: the event "%s" does not exist', event)
    end
    return registerEventListener(event, callback)
  end
)