---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/09 | Author(s): Gopher ]]
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

local events = ({} --[[@as table<string, backbone.observable>]])
local eventFrame = CreateFrame 'Frame' --[[@as Frame]]
eventFrame:RegisterEvent 'ADDON_LOADED'

---
---Responsible for handling the dispatching of game events.
---
eventFrame:SetScript(
  'OnEvent', function(_, eventName, ...)
    local payload = { ... }

    switch(
      eventName,
      {
        ADDON_LOADED = function()
          local addonName = payload[1] --[[@as string]]
          local eventId = string.format(
            'ADDON_LOADED/%s', context.getEventId(addonName)
          )
          if hashmap.contains(events, eventId) then
            hashmap.drop(events, eventId):notify()
          end
        end,

        default = function()
          local eventId = context.getEventId(eventName)
          if hashmap.contains(events, eventId) then
            local event = hashmap.get(events, eventId)
            event:notify(payload)
            
            if #event.observers == 0 then
              eventFrame:UnregisterEvent(eventName)
              hashmap.drop(events, eventId)
            end
          end
        end
      }
    )
  end
)

---
---Register a listener for the specified event.
---
---@param eventName string
---@param listener backbone.observer|backbone.observer-callback
---
backbone.registerEventListener = function(eventName, listener)
  assert(eventName ~= 'ADDON_LOADED',
    'Use `onAddonReady` instead of `registerEventListener` for the "ADDON_LOADED" event.'
  )
  if type(listener) == 'function' then
    listener = { callback = listener }
  end
  local eventId = context.getEventId(eventName)
  if not hashmap.contains(events, eventId) then
    hashmap.set(events, eventId, observable:new())
    eventFrame:RegisterEvent(eventName)
  end
  local event = hashmap.get(events, eventId)
  event:subscribe { callback = listener.callback, persistent = listener.persistent }
end

---
---Remove the provided listener from the specified event.
---
---@param eventName string
---@param listener backbone.observer|backbone.observer-callback
---
backbone.removeEventListener = function(eventName, listener)
  local eventId = context.getEventId(eventName)
  if hashmap.contains(events, eventId) then
    if type(listener) == 'function' then
      listener = { callback = listener }
    end
    local event = hashmap.get(events, eventId)
    event:unsubscribe(listener.callback)
  end
end

---
---Register a listener for the "ADDON_LOADED" event.
---
---@param addonName string
---@param callback backbone.observer-callback
---
backbone.onAddonReady = function(addonName, callback)
  if backbone.isAddonLoaded(addonName) then
    backbone.queueTask(function() callback({}) end)
    return -- the addon is already loaded, exit early.
  end
  local eventId = string.format(
    'ADDON_LOADED/%s', context.getEventId(addonName)
  )
  if not hashmap.contains(events, eventId) then
    hashmap.set(events, eventId, observable:new())
  end
  local event = hashmap.get(events, eventId)
  event:subscribe { callback = callback, persistent = false }
end
