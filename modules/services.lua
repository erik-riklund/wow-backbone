---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/11 | Author(s): Gopher ]]
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
---A table storing registered services, where each key is a service identifier
---and each value is a `backbone.service` instance.
---
---@type table<string, backbone.service>
---
local services = {}

---
---A table used to cache and reuse existing service proxies for better performance.
---Cached objects are weakly referenced to allow garbage collection when no longer in use.
---
---@type table<string, backbone.service-object>
---
local cache = setmetatable({}, { __mode = 'v' })

---
---Create an identifier for a service based on its name.
---
---@param name string
---@return string
---
local getServiceId = function(name)
  return string.lower(name)
end

---
---Register a service with the given name and object.
---
---@param name string
---@param object backbone.service-object
---
backbone.registerService = function(name, object)
  local serviceId = getServiceId(name)
  if hashmap.contains(services, serviceId) then
    local service = hashmap.get(services, serviceId)
    if service.object ~= nil then
      throw('The service "%s" already exists.', name)
    end
    service.object = object
  else
    hashmap.set(services, serviceId, { object = object })
  end
end

---
---Request access to a registered service by its name.
---
---@generic T
---@param name `T`
---@return T
---
backbone.requestService = function(name)
  local serviceId = getServiceId(name)
  if not hashmap.contains(services, serviceId) then
    throw('The requested service "%s" does not exist.', name)
  end

  local service = hashmap.get(services, serviceId)
  if service.object == nil then
    C_AddOns.LoadAddOn(service.supplier)
    while service.object == nil do
      -- defer execution until the addon is loaded.
    end
  end
  if not hashmap.contains(cache, serviceId) then
    hashmap.set(cache, serviceId, createProtectedProxy(service.object))
  end
  return hashmap.get(cache, serviceId)
end

---
---Used internally to register services that should be loaded on demand.
---
---@param addon string
---@param service string
---
context.registerLoadableService = function(addon, service)
  local serviceId = getServiceId(service)
  if hashmap.contains(services, serviceId) then
    throw('The service "%s" already exists.', service)
  end
  hashmap.set(services, serviceId, { supplier = addon })
end
