--[[~ Updated: 2025/07/16 | Author(s): Gopher ]]
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

assert(observable == nil,
  'Global variable conflict: `observable` has already been defined.'
)

---
---Represents an observable object that can be subscribed to by observers.
---
---@class backbone.observable
---@field observers array<backbone.observer>
---
_G.observable = {}

---
---Creates a new observable instance.
---
---@private
---@return backbone.observable
---
observable.new = function(self)
  return inherit(self, { observers = {} })
end

---
---Cleans up non-persistent observers from the observable.
---
---@protected
---
observable.cleanup = function(self)
  local count = #self.observers

  if count > 0 then
    for index = count, 1, -1 do
      if not self.observers[index].persistent then
        array.remove(self.observers, index)
      end
    end
  end
end

---
---Notifies all registered observers with an optional payload.
---
---@param payload? table
---
observable.notify = function(self, payload)
  if payload ~= nil and type(payload) ~= 'table' then
    throw('Expected `payload` to be a table, got %s.', type(payload))
  end

  for _, observer in ipairs(self.observers) do
    backbone.queueTask(function() observer.callback(payload or {}) end)
  end
  
  self:cleanup()
end

---
---Subscribes an observer or a callback function to the observable.
---
---@param observer backbone.observer|backbone.observer-callback
---
observable.subscribe = function(self, observer)
  if type(observer) == 'function' then
    observer = { callback = observer }
  end

  observer.persistent = (observer.persistent == nil) or observer.persistent
  array.append(self.observers, observer)
end

---
---Unsubscribes an observer or a callback function from the observable.
---
---@param observer backbone.observer|backbone.observer-callback
---
observable.unsubscribe = function(self, observer)
  for index, object in ipairs(self.observers) do
    if observer == object or observer == object.callback then
      return array.remove(self.observers, index)
    end
  end
end
