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
---A table storing definitions of all registered services,
---indexed by their standardized ID.
---
---@type table<string, backbone.service>
---
local services = {}

---
---A weak-value cache for service objects,
---allowing them to be garbage-collected when not used.
---
---@type table<string, backbone.service-object>
---
local cache = setmetatable({}, { __mode = 'v' })

---
---Generates a standardized service ID from a given service name.
---
---@param name string
---@return string id
---
local getServiceId = function(name)
  return string.lower(name)
end

---
---Registers a new service with a given name and object.
---
---@param name string
---@param object backbone.service-object
---
backbone.registerService = function(name, object)
  local service_id = getServiceId(name)

  if hashmap.contains(services, service_id) then
    local service = hashmap.get(services, service_id)

    if service.object ~= nil then
      throw('The service "%s" already exists.', name)
    end

    service.object = object
  else
    hashmap.set(services, service_id, { object = object })
  end
end

---
---Retrieves a service object, loading its associated addon if necessary.
---
---@generic T
---
---@param name `T`
---@return T
---
backbone.useService = function(name)
  local service_id = getServiceId(name)

  if not hashmap.contains(services, service_id) then
    throw('The requested service "%s" does not exist.', name)
  end

  local service = hashmap.get(services, service_id)

  if service.object == nil then
    C_AddOns.LoadAddOn(service.supplier)

    while service.object == nil do
      -- defer execution until the addon is loaded.
    end
  end

  if not hashmap.contains(cache, service_id) then
    hashmap.set(cache, service_id, createProtectedProxy(service.object))
  end

  return hashmap.get(cache, service_id)
end

---
---Registers a service as being provided by a specific addon,
---without providing the service object itself yet.
---
---@param addon string
---@param service string
---
context.registerLoadableService = function(addon, service)
  local service_id = getServiceId(service)

  if hashmap.contains(services, service_id) then
    throw('The service "%s" already exists.', service)
  end
  
  hashmap.set(services, service_id, { supplier = addon })
end
