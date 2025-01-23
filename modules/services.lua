---@class __backbone
local context = select(2, ...)

--[[~ Updated: 2025/01/21 | Author(s): Gopher ]]
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
---@type table<string, backbone.service>
---
local services = {}

---
---@type table<string, backbone.service-object>
---
local cache = setmetatable({}, { __mode = 'v' })

---
---@param name string
---@return string id
---
local getServiceId = function(name) return string.lower(name) end

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
---@generic T
---
---@param name `T`
---@return T
---
backbone.useService = function(name)
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
