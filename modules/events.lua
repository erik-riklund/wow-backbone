---@class Backbone
local context = select(2, ...)

--[[~ Updated: 2024/12/06 | Author(s): Gopher ]]

--Backbone - A World of Warcraft addon framework
--Copyright (C) 2024 Erik Riklund (Gopher)
--
--This program is free software: you can redistribute it and/or modify it under the terms
--of the GNU General Public License as published by the Free Software Foundation, either
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU General Public License <https://www.gnu.org/licenses/> for more details.

local registeredEvents = new 'Dictionary'
context.frame:RegisterEvent 'ADDON_LOADED'

--Internal channel used to handle `ADDON_LOADED` events for plugins.
--
context.plugin:createChannel (
  'PLUGIN_LOADED', { internal = true, executeAsync = false }
)

--Channel used by the framework to signal that an addon or plugin is ready to use.
--
context.plugin:createChannel ('ADDON_READY', { executeAsync = false })

--?
--
context.frame:HookScript (
  'OnEvent', function (self, eventName, ...)
    ---@cast eventName string
    
    if eventName == 'ADDON_LOADED' then
      local addon = ... --[[@as string]]

      if backbone.hasPlugin (addon) then
        local pluginId = string.lower (addon)
        local plugin = context.plugins:getEntry (pluginId) --[[@as Backbone.Plugin]]

        context.plugin:triggerChannel ('PLUGIN_LOADED', plugin)
      end

      context.plugin:triggerChannel ('ADDON_READY', addon)
      return -- exit early.
    end

    ---@type Listenable?
    local event = registeredEvents:getEntry (eventName)

    if event ~= nil then
      event:invokeListeners ( Vector {...} )
    end

    if event == nil or (event and event:getListenerCount () == 0) then
      context.frame:UnregisterEvent (eventName)
      registeredEvents:dropEntry (eventName)
    end
  end
)

---@param eventName string
---@param listener Listener
---
local registerListener = function(eventName, listener)
  if not registeredEvents:getEntry (eventName) then
    registeredEvents:setEntry (eventName, new 'Listenable')
    context.frame:RegisterEvent (eventName)
  end

  registeredEvents:getEntry (eventName):registerListener (listener)
end

---@param eventName string
---@param listenerId string
---
local removeListener = function(eventName, listenerId)
  registeredEvents:getEntry (eventName):removeListener (listenerId)
end

-- FRAMEWORK API --

---@param addon string
---Checks whether the specified addon is loaded.
---* Returns `true` if the addon is loaded, `false` otherwise.
---
backbone.isAddonLoaded = function (addon)
  return select (2, C_AddOns.IsAddOnLoaded (addon)) --[[@as boolean]]
end

---@param addon string
---@param callback function
---Registers a callback to be executed when the specified addon is loaded.
---
backbone.onAddonReady = function (addon, callback)
  if backbone.isAddonLoaded (addon) then
    return callback () -- execute the callback function and exit early.
  end

  local listenerId = string.format ('%s/%s', addon, GetTimePreciseSec())

  context.plugin:registerChannelListener (
    'ADDON_READY', {
      identifier = listenerId,
      callback = function (loadedAddon)
        ---@cast loadedAddon string
        
        if loadedAddon == addon then
          callback () -- execute the callback function.
          context.plugin:removeChannelListener ('ADDON_READY', listenerId)
        end
      end
    }
  )
end

-- PLUGIN API --

---@class Backbone.Plugin
local eventsAPI = context.pluginAPI

---@param plugin Backbone.Plugin
---@param eventName string
---@param listenerId string
---
local getEventListenerId = function (plugin, eventName, listenerId)
  return string.format ('%s/%s/%s', plugin:getName(), eventName, listenerId or 'anonymous')
end

---@param callback function
---Registers a callback to be executed when the plugin is ready.
---* May be called multiple times. Callbacks are executed in the order they were registered.
---
eventsAPI.onReady = function (self, callback)
  backbone.onAddonReady (self.name, callback)
end

---@param eventName string
---@param listener Listener
---Registers a listener for the specified event.
---
eventsAPI.registerEventListener = function (self, eventName, listener)
  listener.id = getEventListenerId (self, eventName, listener.id)
  registerListener (eventName, listener)
end

---@param eventName string
---@param listenerId string
---Removes a listener from the specified event.
---
eventsAPI.removeEventListener = function (self, eventName, listenerId)
  removeListener (eventName, getEventListenerId (self, eventName, listenerId))
end
