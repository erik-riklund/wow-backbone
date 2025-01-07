--[[~ Updated: 2025/01/07 | Author(s): Gopher ]]
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
---
---
---@class backbone.observable
---@field private observers backbone.observer[]
---
_G.observable = {}

---
---
---
---@private
---@return backbone.observable
---
observable.new = function(self)
  local instance = setmetatable({ observers = {} }, { __index = observable })
  return instance --[[@as backbone.observable]]
end

---
---
---
---@param observer backbone.observer|backbone.observer-callback
---
observable.subscribe = function(self, observer) end

---
---
---
---@param observer backbone.observer|backbone.observer-callback
---
observable.unsubscribe = function(self, observer) end

---
---
---
---@param payload? table
---
observable.notify = function(self, payload) end

---
---
---
observable.cleanup = function(self) end

-- ---
--   ---Register a new observer.
--   ---
--   ---@param self backbone.observable
--   ---@param observer backbone.observer|backbone.observer-callback
--   ---
--   subscribe = function(self, observer)
--     if type(observer) == 'function' then
--       observer = { callback = observer }
--     end
--     observer.persistent = (observer.persistent == nil) or observer.persistent
--     array.insert(self.observers, observer)
--   end,

--   ---
--   ---Remove a previously registered observer.
--   ---
--   ---@param self backbone.observable
--   ---@param observer backbone.observer|backbone.observer-callback
--   ---
--   unsubscribe = function(self, observer)
--     for index, object in ipairs(self.observers) do
--       if observer == object or observer == object.callback then
--         return array.remove(self.observers, index)
--       end
--     end
--   end,

--   ---
--   ---Notify all registered observers, passing the provided payload to each.
--   ---
--   ---@param self backbone.observable
--   ---@param payload? table
--   ---
--   notify = function(self, payload)
--     assert(
--       payload == nil or type(payload) == 'table',
--       'Expected argument `payload` to be a table.'
--     )
--     for _, observer in ipairs(self.observers) do
--       backbone.queueTask(
--         function() observer.callback(payload or {}) end
--       )
--     end
--     self:cleanup()
--   end,

--   ---
--   ---Remove non-persistent observers from the list.
--   ---
--   ---@param self backbone.observable
--   ---
--   cleanup = function(self)
--     local count = #self.observers
--     if count > 0 then
--       for index = count, 1, -1 do
--         if not self.observers[index].persistent then
--           array.remove(self.observers, index)
--         end
--       end
--     end
--   end,

--   ---
--   ---Return the number of registered observers.
--   ---
--   ---@param self backbone.observable
--   ---@return number
--   ---
--   listeners = function(self)
--     return #self.observers
--   end