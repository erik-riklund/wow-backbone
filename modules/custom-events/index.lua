---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/07/19 | Author(s): Gopher ]]
--
-- Backbone - An addon development framework for World of Warcraft.
--
--This program is free software: you can redistribute it and/or modify it under the terms
--of the GNU General Public License as published by the Free Software Foundation, either
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU General Public License <https://www.gnu.org/licenses/> for more details.

---
---A table storing all custom events, indexed by their standardized event ID.
---
---@type table<string, backbone.custom-event>
---
local events = {}

---
---Generates a standardized event ID from a given event name.
---
---@param event string
---@return string id
---
context.getEventId = function(event)
  return string.upper(event)
end

---
---Creates and registers a new custom event, returning a dispatch function
---that can be used by the event's owner to fire the event.
---
---@param token backbone.token
---@param name string
---@param access? 'public'|'private'
---
---@return fun(payload: table)
---
backbone.createCustomEvent = function(token, name, access)
  local event_id = context.getEventId(name)

  if hashmap.contains(events, event_id) then
    throw('A custom event with the name "%s" already exists.', name)
  elseif access ~= nil and access ~= 'public' and access ~= 'private' then
    throw('Invalid access level `%s` for custom event `%s`, must be `public` or `private`.', access, name)
  end

  hashmap.set(events, event_id,
    { owner = token, name = name, access = access or 'public', observers = observable:new() }
  )

  return function (payload)
    backbone.triggerCustomEvent(token, name, payload)
  end
end

---
---Triggers a custom event, notifying all its registered listeners.
---
---@param token backbone.token
---@param event_name string
---@param payload? table
---
backbone.triggerCustomEvent = function(token, event_name, payload)
  local event_id = context.getEventId(event_name)

  if not hashmap.contains(events, event_id) then
    throw('The specified event `%s` does not exist.', event_name)
  end

  local event = hashmap.get(events, event_id)

  if event.owner ~= token then
    throw('The provided token `%s` does not own the event `%s`.', token.name, event_name)
  end

  event.observers:notify(payload)
end

---
---Registers a listener (callback function) for a custom event.
---
---@param event_name string
---@param listener backbone.custom-event-listener|backbone.observer-callback
---
backbone.registerCustomEventListener = function(event_name, listener)
  local event_id = context.getEventId(event_name)

  if not hashmap.contains(events, event_id) then
    throw('The specified event `%s` does not exist.', event_name)
  end

  if type(listener) == 'function' then
    listener = { callback = listener }
  end

  local event = hashmap.get(events, event_id)

  if event.access ~= 'public' and event.owner ~= listener.token then
    throw('The event `%s` is not accessible by the provided token.', event_name)
  end

  event.observers:subscribe {
    callback = listener.callback, persistent = listener.persistent
  }
end

---
---Removes a previously registered listener from a custom event.
---
---@param event_name string
---@param listener backbone.custom-event-listener|backbone.observer-callback
---
backbone.removeCustomEventListener = function(event_name, listener)
  local event_id = context.getEventId(event_name)

  if not hashmap.contains(events, event_id) then
    throw('The specified event `%s` does not exist.', event_name)
  end

  if type(listener) == 'function' then
    listener = { callback = listener }
  end

  local event = hashmap.get(events, event_id)

  if event.access ~= 'public' and event.owner ~= listener.token then
    throw('The event `%s` is not accessible by the provided token.', event_name)
  end

  event.observers:unsubscribe(listener.callback)
end
