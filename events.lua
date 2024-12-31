---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2024/12/30 | Author(s): Gopher ]]
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

---@class backbone.addon
local __addon = context.__addon

local array = backbone.utils.array
local dictionary = backbone.utils.dictionary

--=============================================================================
-- COMPONENT > OBSERVABLE:
-- <add description of the component>
--=============================================================================

---
---Represents an object that can be observed, allowing for custom event handling.
---
---@class backbone.observable
---@field observers array<backbone.observer>
---
local observable =
{
  ---
  ---Register a new observer.
  ---
  ---@param self backbone.observable
  ---@param observer backbone.observer|backbone.observer-callback
  ---
  subscribe = function(self, observer)
    if type(observer) == 'function' then
      observer = { callback = observer }
    end
    observer.persistent = (observer.persistent == nil) or observer.persistent
    array.insertElement(self.observers, observer)
  end,

  ---
  ---Remove a previously registered observer.
  ---
  ---@param self backbone.observable
  ---@param observer backbone.observer|backbone.observer-callback
  ---
  unsubscribe = function(self, observer)
    for index, object in ipairs(self.observers) do
      if observer == object or observer == object.callback then
        return array.removeElement(self.observers, index)
      end
    end
  end,

  ---
  ---Notify all registered observers, passing the provided payload to each.
  ---
  ---@param self backbone.observable
  ---@param payload? table
  ---
  notify = function(self, payload)
    assert(
      payload == nil or type(payload) == 'table',
      'Expected argument `payload` to be a table.'
    )
    for _, observer in ipairs(self.observers) do
      backbone.queueTask(
        function() observer.callback(payload or {}) end
      )
    end
    self:cleanup()
  end,

  ---
  ---Remove non-persistent observers from the list.
  ---
  ---@param self backbone.observable
  ---
  cleanup = function(self)
    local count = #self.observers
    if count > 0 then
      for index = count, 1, -1 do
        if not self.observers[index].persistent then
          array.removeElement(self.observers, index)
        end
      end
    end
  end,

  ---
  ---Return the number of registered observers.
  ---
  ---@param self backbone.observable
  ---@return number
  ---
  listeners = function(self)
    return #self.observers
  end
}

---
---!
---
---@return backbone.observable
---
local createObservable = function()
  return setmetatable({ observers = {} }, { __index = observable }) --[[@as backbone.observable]]
end

--=============================================================================
-- NETWORK CHANNELS:
-- <add description of the module>
--=============================================================================

local channels = ({} --[[@as table<string, backbone.channel>]])
local getChannelId = function(name) return string.upper(name) end

---
---Create a new communication channel with the provided options.
---
---@param options backbone.channel-options
---
local createChannel = function(options)
  local owner = options.owner
  local channel_name = options.name
  local access = options.access or 'public'

  assert(
    owner == backbone.getAddon(owner.name),
    'Expected argument `owner` to be a registered addon.'
  )

  local channel_id = getChannelId(channel_name)
  assert(
    not dictionary.hasEntry(channels, channel_id),
    'A channel with the name "' .. channel_name .. '" already exists.'
  )

  dictionary.setEntry(
    channels, channel_id, {
      owner = owner,
      name = channel_name,
      subscribers = createObservable(),
      access = access
    } --[[@as backbone.channel]]
  )
end

---
---Create a public channel owned by the current addon.
---
---@param self backbone.addon
---@param name string
---
__addon.createPublicChannel = function(self, name)
  createChannel { owner = self, name = name, access = 'public' }
end

---
---Create a private channel for the current addon.
---
---@param self backbone.addon
---@param name string
---
__addon.createPrivateChannel = function(self, name)
  createChannel { owner = self, name = name, access = 'private' }
end

---
---Get the channel object with the specified name.
---
---@param name string
---@return backbone.channel
---
local getChannel = function(name)
  local channel_id = getChannelId(name)
  assert(
    dictionary.hasEntry(channels, channel_id),
    'There is no channel with the name "' .. name .. '".'
  )
  return dictionary.getEntry(channels, channel_id)
end

---
---Register a subscriber to the specified channel.
---
---@param caller backbone.addon
---@param channel_name string
---@param callback backbone.observer-callback
---@param persistent? boolean
---
local subscribe = function(caller, channel_name, callback, persistent)
  local channel = getChannel(channel_name)
  assert(
    channel.access == 'public' or caller == channel.owner,
    'You do not have permission to subscribe to the channel "' .. channel_name .. '".'
  )
  channel.subscribers:subscribe {
    callback = callback, persistent = (persistent == nil) or persistent
  }
end

---
---Register a subscriber to the channel.
---
---@param self backbone.addon
---@param channel_name string
---@param callback backbone.observer-callback
---
__addon.registerChannelSubscriber = function(self, channel_name, callback)
  subscribe(self, channel_name, callback, true)
end

---
---Register a one-time subscriber to the channel.
---
---@param self backbone.addon
---@param channel_name string
---@param callback backbone.observer-callback
---
__addon.registerChannelSubscriberOnce = function(self, channel_name, callback)
  subscribe(self, channel_name, callback, false)
end

---
---Remove the specified subscriber from the channel.
---
---@param self backbone.addon
---@param channel_name string
---@param callback backbone.observer-callback
---
__addon.removeChannelSubscriber = function(self, channel_name, callback)
  local channel = getChannel(channel_name)
  if channel.access == 'public' or self == channel.owner then
    channel.subscribers:unsubscribe(callback)
  end
end

---
---Notify all subscribers on the specified channel, passing the provided payload.
---
---@param self backbone.addon
---@param channel_name string
---@param payload? table
---
__addon.notifyChannelSubscribers = function(self, channel_name, payload)
  local channel = getChannel(channel_name)
  assert(
    self == channel.owner,
    'Only the owner of the channel "' .. channel.name .. '" can transmit messages.'
  )
  channel.subscribers:notify(payload)
end

--=============================================================================
-- EVENT HANDLING:
-- <add description of the module>
--=============================================================================

local eventFrame = CreateFrame 'Frame' --[[@as Frame]]
local events = ({} --[[@as table<string, backbone.observable>]])
local load_events = ({} --[[@as table<string, backbone.observable>]])

---
---Responsible for dispatching events.
---
eventFrame:RegisterEvent 'ADDON_LOADED'
eventFrame:SetScript(
  'OnEvent', function(...)
    local arguments = { select(1, ...) }
    local event_name = array.removeElement(arguments, 1) --[[@as WowEvent]]

    if event_name == 'ADDON_LOADED' then
      local addon_name = arguments[1] --[[@as string]]

      if backbone.hasAddon(addon_name) then
        local loaded_addon = context.getAddon(addon_name)
        array.forEach(
          context.addon_initializers,
          function(_, initializer) initializer(loaded_addon) end
        )
      end
      
      if dictionary.hasEntry(load_events, addon_name) then
        dictionary.getEntry(load_events, addon_name):notify()
        dictionary.dropEntry(load_events, addon_name)
      end
    else
      local event = dictionary.getEntry(events, event_name)
      event:notify(arguments)

      if event:listeners() == 0 then
        eventFrame:UnregisterEvent(event_name)
        dictionary.dropEntry(events, event_name)
      end
    end
  end
)

---
---Registers a callback to be invoked when the specified addon is fully initialized.
---
---@param addon_name string
---@param callback fun()
---
backbone.onAddonReady = function(addon_name, callback)
  if C_AddOns.IsAddOnLoaded(addon_name) then
    return callback() -- the specified addon is already loaded.
  end

  if not dictionary.hasEntry(load_events, addon_name) then
    dictionary.setEntry(
      load_events, addon_name, createObservable()
    )
  end
  dictionary.getEntry(load_events, addon_name):subscribe(callback)
end

---
---Registers a callback to be invoked when the addon is fully initialized.
---
---@param self backbone.addon
---@param callback fun()
---
__addon.onReady = function(self, callback)
  backbone.onAddonReady(self.name, callback)
end

---
---Registers the specified event listener.
---
---@param event_name WowEvent
---@param callback backbone.observer-callback
---@param persistent? boolean
---
local listen = function(event_name, callback, persistent)
  if not dictionary.hasEntry(events, event_name) then
    dictionary.setEntry(
      events, event_name, createObservable()
    )
    eventFrame:RegisterEvent(event_name)
  end
  dictionary.getEntry(events, event_name):subscribe {
    callback = callback, persistent = (persistent == nil) or persistent
  }
end

---
---Register an event listener.
---
---@param event_name WowEvent
---@param callback backbone.observer-callback
---
backbone.registerEventListener = function(event_name, callback)
  listen(event_name, callback, true)
end

---
---Register a one-time event listener.
---
---@param event_name WowEvent
---@param callback backbone.observer-callback
---
backbone.registerEventListenerOnce = function(event_name, callback)
  listen(event_name, callback, false)
end

---
---Remove the specified event listener.
---
---@param event_name WowEvent
---@param callback backbone.observer-callback
---
backbone.removeEventListener = function(event_name, callback)
  assert(
    dictionary.hasEntry(events, event_name),
    'The event "' .. event_name .. '" has not been registered.'
  )
  dictionary.getEntry(events, event_name):unsubscribe(callback)
end
