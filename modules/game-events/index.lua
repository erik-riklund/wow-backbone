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
---A collection of registered game event handlers.
---
---@type table<string, backbone.observable>
---
local events = {}

---
---A hidden UI frame used to register and receive game events.
---
---@type Frame
---
local event_frame = CreateFrame 'Frame'
event_frame:RegisterEvent 'ADDON_LOADED'

---
---This script dispatches incoming game events to registered listeners.
---
event_frame:SetScript(
  'OnEvent', function(_, event_name, ...)
    local payload = { ... }

    switch(
      event_name,
      {
        ADDON_LOADED = function()
          local addon_name = payload[1] --[[@as string]]
          local event_id = string.format(
            'ADDON_LOADED/%s', context.getEventId(addon_name)
          )

          if hashmap.contains(events, event_id) then
            hashmap.drop(events, event_id):notify(payload)
          end
        end,

        default = function()
          local event_id = context.getEventId(event_name)

          if hashmap.contains(events, event_id) then
            local event = hashmap.get(events, event_id)
            event:notify(payload)

            if #event.observers == 0 then
              event_frame:UnregisterEvent(event_name)
              hashmap.drop(events, event_id)
            end
          end
        end
      }
    )
  end
)

---
---Registers a callback function to listen for a specific game event.
---
---@param event_name string
---@param listener backbone.observer|backbone.observer-callback
---
backbone.registerEventListener = function(event_name, listener)
  if event_name == 'ADDON_LOADED' then
    throw('Use `onAddonLoaded` instead of `registerEventListener` for the "ADDON_LOADED" event.')
  end

  if type(listener) == 'function' then
    listener = { callback = listener }
  end

  local event_id = context.getEventId(event_name)

  if not hashmap.contains(events, event_id) then
    hashmap.set(events, event_id, observable:new())
    event_frame:RegisterEvent(event_name)
  end

  local event = hashmap.get(events, event_id)

  event:subscribe {
    callback = listener.callback,
    persistent = listener.persistent
  }
end

---
---Removes a previously registered listener from a game event.
---
---@param event_name string
---@param listener backbone.observer|backbone.observer-callback
---
backbone.removeEventListener = function(event_name, listener)
  local event_id = context.getEventId(event_name)

  if hashmap.contains(events, event_id) then
    if type(listener) == 'function' then
      listener = { callback = listener }
    end
    
    local event = hashmap.get(events, event_id)
    event:unsubscribe(listener.callback)
  end
end

---
---Registers a callback to be executed once a specific addon has finished loading.
---
---@param addon_name string
---@param callback backbone.observer-callback
---
backbone.onAddonLoaded = function(addon_name, callback)
  if backbone.isAddonLoaded(addon_name) then
    backbone.queueTask(function() callback({}) end)
    return -- the addon is already loaded, exit early.
  end

  local event_id = string.format(
    'ADDON_LOADED/%s', context.getEventId(addon_name)
  )

  if not hashmap.contains(events, event_id) then
    hashmap.set(events, event_id, observable:new())
  end
  
  local event = hashmap.get(events, event_id)
  event:subscribe { callback = callback, persistent = false }
end
