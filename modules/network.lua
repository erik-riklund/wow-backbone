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

local channels = new 'Dictionary'

---@param owner Backbone.Plugin
---@param name string
---@param options? Backbone.ChannelOptions
---
local createChannel = function (owner, name, options)
  options = options or {}

  local channelId = string.upper (name)
  if channels:hasEntry (channelId) then
    backbone.throw ('The channel "%s" already exists.', name)
  end

  local channel = new 'Listenable' --[[@as Backbone.Channel]]
  channels:setEntry(channelId, backbone.integrateTables (
    channel, { options, { name = name, owner = owner } }
  ))
end

---@param caller Backbone.Plugin
---@param channelName string
---@param listener Listener
---
local registerListener = function (caller, channelName, listener)
  local channelId = string.upper (channelName)
  local channel = channels:getEntry (channelId) --[[@as Backbone.Channel]]

  if not channel then
    backbone.throw ('The channel "%s" does not exist.', channelName)
  end

  if channel.internal and caller ~= channel.owner then
    backbone.throw (
      'Unable to register listener "%s" on internal channel "%s".'
        , listener.id, channelName
    )
  end

  channel:registerListener (listener)
end

---@param caller Backbone.Plugin
---@param channelName string
---@param listenerId string
---
local removeListener = function (caller, channelName, listenerId)
  local channelId = string.upper (channelName)
  local channel = channels:getEntry (channelId) --[[@as Backbone.Channel]]

  if not channel then
    backbone.throw ('The channel "%s" does not exist.', channelName)
  end

  if not channel.internal or caller == channel.owner then
    channel:removeListener (listenerId)
  end
end

---@param caller Backbone.Plugin
---@param channelName string
---@param ... unknown
---
local invokeListeners = function (caller, channelName, ...)
  local channelId = string.upper (channelName)
  local channel = channels:getEntry (channelId) --[[@as Backbone.Channel]]

  if not channel then
    backbone.throw ('The channel "%s" does not exist.', channelName)
  end

  if caller ~= channel.owner then
    backbone.throw ('Unable to invoke listeners on channel "%s".', channelName)
  end

  channel:invokeListeners ( Vector {...} )
end

-- PLUGIN API --

---@class Backbone.Plugin
local networkAPI = context.pluginAPI

---@param plugin Backbone.Plugin
---@param channelName string
---@param id string
---
local createListenerId = function (plugin, channelName, id)
  return string.format ('%s/%s/%s', plugin:getName(), channelName, id or 'anonymous')
end

---@param name string
---@param options? Backbone.ChannelOptions
---Creates a new channel with the specified name and options.
---
networkAPI.createChannel = function (self, name, options)
  createChannel (self, name, options)
end

---@param channelName string
---@param listener Listener
---Registers a listener on the specified channel.
---
networkAPI.registerChannelListener = function (self, channelName, listener)
  listener.id = createListenerId (self, channelName, listener.id)
  registerListener (self, channelName, listener)
end

---@param channelName string
---@param listenerId string
---Removes a listener from the specified channel.
---
networkAPI.removeChannelListener = function (self, channelName, listenerId)
  removeListener (self, channelName, listenerId)
end

---@param channelName string
---@param ... unknown
---Invokes all registered listeners on the specified channel.
---* Arguments are passed to the listeners' callback functions.
---
networkAPI.triggerChannel = function (self, channelName, ...)
  invokeListeners (self, channelName, ...)
end
