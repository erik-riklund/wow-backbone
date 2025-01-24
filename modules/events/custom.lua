---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/21 | Author(s): Gopher ]]
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
---@type table<string, backbone.custom-event>
---
local events = {}

---
---@param event string
---@return string id
---
context.getEventId = function(event) return string.upper(event) end

---
---@param token backbone.token
---@param name string
---@param access? 'public'|'private'
---
backbone.createCustomEvent = function(token, name, access)
  local eventId = context.getEventId(name)
  if hashmap.contains(events, eventId) then
    throw('A custom event with the name "%s" already exists.', name)
  end
  if access ~= nil and access ~= 'public' and access ~= 'private' then
    throw('Invalid access level `%s` for custom event `%s`, must be `public` or `private`.', access, name)
  end
  hashmap.set(events, eventId,
    { owner = token, name = name, access = access or 'public', observers = observable:new() }
  )
end

---
---@param token backbone.token
---@param eventName string
---@param payload? table
---
backbone.triggerCustomEvent = function(token, eventName, payload)
  local eventId = context.getEventId(eventName)
  if not hashmap.contains(events, eventId) then
    throw('The specified event `%s` does not exist.', eventName)
  end
  local event = hashmap.get(events, eventId)
  if event.owner ~= token then
    throw('The provided token `%s` does not own the event `%s`.', token.name, eventName)
  end
  event.observers:notify(payload)
end

---
---@param eventName string
---@param listener backbone.custom-event-listener|backbone.observer-callback
---
backbone.registerCustomEventListener = function(eventName, listener)
  local eventId = context.getEventId(eventName)
  if not hashmap.contains(events, eventId) then
    throw('The specified event `%s` does not exist.', eventName)
  end
  if type(listener) == 'function' then
    listener = { callback = listener }
  end
  local event = hashmap.get(events, eventId)
  if event.access ~= 'public' and event.owner ~= listener.token then
    throw('The event `%s` is not accessible by the provided token.', eventName)
  end
  event.observers:subscribe {
    callback = listener.callback, persistent = listener.persistent
  }
end

---
---@param eventName string
---@param listener backbone.custom-event-listener|backbone.observer-callback
---
backbone.removeCustomEventListener = function(eventName, listener)
  local eventId = context.getEventId(eventName)
  if not hashmap.contains(events, eventId) then
    throw('The specified event `%s` does not exist.', eventName)
  end
  if type(listener) == 'function' then
    listener = { callback = listener }
  end
  local event = hashmap.get(events, eventId)
  if event.access ~= 'public' and event.owner ~= listener.token then
    throw('The event `%s` is not accessible by the provided token.', eventName)
  end
  event.observers:unsubscribe(listener.callback)
end
