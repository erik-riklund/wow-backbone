--  ____             _    _                                          
-- | __ )  __ _  ___| | _| |__   ___  _ __   ___   _                 
-- |  _ \ / _` |/ __| |/ / '_ \ / _ \| '_ \ / _ \ (_)                
-- | |_) | (_| | (__|   <| |_) | (_) | | | |  __/  _                 
-- |____/ \__,_|\___|_|\_\_.__/ \___/|_| |_|\___| (_)        _       
--  / ___|   _ ___| |_ ___  _ __ ___     _____   _____ _ __ | |_ ___ 
-- | |  | | | / __| __/ _ \| '_ ` _ \   / _ \ \ / / _ \ '_ \| __/ __|
-- | |__| |_| \__ \ || (_) | | | | | | |  __/\ V /  __/ | | | |_\__ \
--  \____\__,_|___/\__\___/|_| |_| |_|  \___| \_/ \___|_| |_|\__|___/                                                                   
--                                                      version 1.0.0
--
-- https://github.com/erik-riklund/wow-backbone (2025)

--
--
-- Custom events handler
--
-- Implements a publisher/subscriber system for addon events. Events are registered
-- by name and listeners are invoked via `Backbone.ExecuteCallback` for safe dispatch.
--

local events = {} -- event_id (key) -> list of callbacks (value).

local eventExists = function (event)
  return events[string.upper(event)] ~= nil
end

local createEvent = function (name)
  events[string.upper(name)] = {}
end

local registerEventListener = function (event, callback)
  local event_id = string.upper(event)
  events[event_id] = events[event_id] or {}
  table.insert(events[event_id], callback)
  
  return function ()
    events[event_id] = each.value(
      events[event_id], function (listener)
        return when(listener ~= callback, listener, nil)
      end
    )
  end
end

local emitEvent = function (event, ...)
  local args = {...}
  each.value(events[string.upper(event)] or {},
    function (callback)
      Backbone.ExecuteCallback(
        function() callback(unpack(args)) end
      )
    end
  )
end

--
-- The public API for custom events
--
-- These functions expose the custom event functionality through the `Backbone` API.
--

Backbone.extend(
  'CreateEvent', function (name)
    if eventExists(name) then
      throw ('Failed to create event, "%s" already exists', name)
    end
    
    createEvent(name)
    return function (...) emitEvent(name, ...) end
  end
)

Backbone.extend(
  'OnCustomEvent', function (event, callback)
    if not eventExists(event) then
      throw ('Failed to register listener. The event "%s" does not exist', event)
    end
    return registerEventListener(event, callback)
  end
)