--[[~ Updated: 2025/01/08 | Author(s): Gopher ]]
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
---Represents an observable object to which observers can be subscribed.
---
---@class backbone.observable
---@field observers array<backbone.observer>
---
_G.observable = {}

---
---Create a new observable instance.
---
---@private
---@return backbone.observable
---
observable.new = function(self)
  return inherit(self, { observers = {} })
end

---
---Remove observers that are not marked as persistent from the observable.
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
---Notify all subscribed observers, passing along the provided `payload`.
---
---@param payload? table
---
observable.notify = function(self, payload)
  assert(
    payload == nil or type(payload) == 'table', string.format(
      'Expected `payload` to be a table, got %s instead.', type(payload)
    )
  )
  for _, observer in ipairs(self.observers) do
    backbone.queueTask(
      function() observer.callback(payload or {}) end
    )
  end
  self:cleanup()
end

---
---Subscribe an observer to the observable. The observer can be either an object
---with a `callback` function and an optional `persistent` flag, or a standalone
---callback function.
---
---* Observers are marked as persistent by default unless specified otherwise.
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
---Unsubscribes an observer from the observable. The provided `observer` must be a
---reference to an observer object or its callback function.
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
