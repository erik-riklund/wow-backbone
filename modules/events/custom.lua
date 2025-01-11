---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/10 | Author(s): Gopher ]]
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

local events = ({} --[[@as table<string, backbone.custom-event>]])

---
---Create an identifier for a custom event based on its name.
---
---@param event string
---@return string
---
context.getEventId = function(event)
  return string.upper(event)
end

---
---Create a new custom event with the specified name and access level.
---
---@param token backbone.token
---@param name string
---@param access? 'public'|'private'
---
backbone.createCustomEvent = function(token, name, access)
  local eventId = context.getEventId(name)
  assert(
    not hashmap.contains(events, eventId), string.format(
      'A custom event with the name `%s` already exists.', name
    )
  )
  assert(
    access == nil or access == 'public' or access == 'private', string.format(
      'Invalid access level `%s` for custom event `%s`, must be `public` or `private`.', access, name
    )
  )
  hashmap.set(
    events, eventId, {
      owner = token,
      name = name,
      access = access or 'public',
      observers = observable:new()
    }
  )
end

---
---Trigger the specified custom event, passing the provided payload to its subscribers.
---
---@param token backbone.token
---@param eventName string
---@param payload? table
---
backbone.triggerCustomEvent = function(token, eventName, payload)
  local eventId = context.getEventId(eventName)
  assert(
    hashmap.contains(events, eventId), string.format(
      'The specified event `%s` does not exist.', eventName
    )
  )
  local event = hashmap.get(events, eventId)
  assert(
    event.owner == token, string.format(
      'The specified token `%s` does not own the event `%s`.', token.name, eventName
    )
  )
  event.observers:notify(payload)
end

---
---Register a listener for the specified custom event.
---
---@param eventName string
---@param listener backbone.custom-event-listener|backbone.observer-callback
---
backbone.registerCustomEventListener = function(eventName, listener)
  local eventId = context.getEventId(eventName)
  assert(
    hashmap.contains(events, eventId), string.format(
      'The specified event `%s` does not exist.', eventName
    )
  )
  if type(listener) == 'function' then
    listener = { callback = listener }
  end
  local event = hashmap.get(events, eventId)
  assert(
    event.access == 'public' or event.owner == listener.token, string.format(
      'The event `%s` is not accessible by the provided token.', eventName
    )
  )
  event.observers:subscribe {
    callback = listener.callback,
    persistent = listener.persistent
  }
end

---
---Remove the provided listener from the specified custom event.
---
---@param eventName string
---@param listener backbone.custom-event-listener|backbone.observer-callback
---
backbone.removeCustomEventListener = function(eventName, listener)
  local eventId = context.getEventId(eventName)
  assert(
    hashmap.contains(events, eventId), string.format(
      'The specified event `%s` does not exist.', eventName
    )
  )
  if type(listener) == 'function' then
    listener = { callback = listener }
  end
  local event = hashmap.get(events, eventId)
  assert(
    event.access == 'public' or event.owner == listener.token, string.format(
      'The event `%s` is not accessible by the provided token.', eventName
    )
  )
  event.observers:unsubscribe(listener.callback)
end
