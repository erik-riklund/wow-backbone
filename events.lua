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
  ---Register an observer that will only be executed once.
  ---
  ---@param self backbone.observable
  ---@param observer backbone.observer-callback
  ---
  subscribeOnce = function(self, observer)
    self:subscribe { callback = observer, persistent = false }
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
backbone.createChannel = function(options)
  local owner = options.owner
  local channel_name = options.name
  local access = options.access or 'public'

  assert(
    owner == backbone.getAddon(owner.name),
    'Expected argument `owner` to be a registered addon.'
  )
  assert(
    access == 'public' or access == 'private',
    'Expected argument `access` to be either "public" or "private".'
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
  backbone.createChannel { owner = self, name = name, access = 'public' }
end

---
---Create a private channel for the current addon.
---
---@param self backbone.addon
---@param name string
---
__addon.createPrivateChannel = function(self, name)
  backbone.createChannel { owner = self, name = name, access = 'private' }
end

---
---!
---
---@param caller backbone.addon
---@param channel_name string
---@param callback backbone.observer-callback
---@param persistent? boolean
---
local subscribe = function(caller, channel_name, callback, persistent)
  local channel_id = getChannelId(channel_name)
  assert(
    dictionary.hasEntry(channels, channel_id),
    'There is no channel with the name "' .. channel_name .. '".'
  )
  local channel = dictionary.getEntry(channels, channel_id)
  assert(
    channel.access == 'public' or caller == channel.owner,
    'You do not have permission to subscribe to the channel "' .. channel_name .. '".'
  )
  channel.subscribers:subscribe {
    callback = callback, persistent = (persistent == nil) or persistent
  }
end

---
---?
---
---@param self backbone.addon
---@param channel_name string
---@param callback backbone.observer-callback
---
__addon.subscribe = function(self, channel_name, callback)
  subscribe(self, channel_name, callback, true)
end

---
---?
---
---@param self backbone.addon
---@param channel_name string
---@param callback backbone.observer-callback
---
__addon.subscribeOnce = function(self, channel_name, callback)
  subscribe(self, channel_name, callback, false)
end

---
---?
---
---@param self backbone.addon
---@param channel_name string
---@param callback backbone.observer-callback
---
__addon.unsubscribe = function(self, channel_name, callback)
  local channel_id = getChannelId(channel_name)
  assert(
    dictionary.hasEntry(channels, channel_id),
    'There is no channel with the name "' .. channel_name .. '".'
  )
  local channel = dictionary.getEntry(channels, channel_id)
  if channel.access == 'public' or self == channel.owner then
    channel.subscribers:unsubscribe(callback)
  end
end

---
---?
---
---@param self backbone.addon
---@param channel_name string
---@param payload? table
---
__addon.transmit = function(self, channel_name, payload)
  local channel_id = getChannelId(channel_name)
  assert(
    dictionary.hasEntry(channels, channel_id),
    'There is no channel with the name "' .. channel_name .. '".'
  )

  local channel = dictionary.getEntry(channels, channel_id)
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
local events = ({} --[[@as table<string, array<backbone.observable>>]])

---
---!
---
eventFrame:RegisterEvent 'ADDON_LOADED'
eventFrame:SetScript(
  'OnEvent', function(_, ...)
    local event_name = (...) --[[@as WowEvent]]
    if event_name == 'ADDON_LOADED' then
      
    else
      -- TODO: implement handling of other events.
    end
  end
)
