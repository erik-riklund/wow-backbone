---@class Backbone
local context = select(2, ...)

--[[~ Updated: 2024/12/11 | Author(s): Gopher ]]

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

local services = new 'Dictionary'

---@param name string
---@return string
---
local getServiceId = function (name)
  return string.lower (name)
end

---@param owner Backbone.Plugin
---@param name string
---@param initializer Backbone.ServiceInitializer
---
local registerService = function (owner, name, initializer)
  local serviceId = getServiceId (name)

  if services:hasEntry (serviceId) then
    ---@type Backbone.Service
    local service = services:getEntry (serviceId)

    if service.initializer ~= nil or service.provider ~= owner:getName() then
      backbone.throw ('The service "%s" is already registered.', name)
    end

    service.initializer = initializer
    return -- exit early as the service was loaded on demand.
  end

  ---@type Backbone.Service
  local service = { provider = owner:getName(), initializer = initializer }

  services:setEntry (serviceId, service)
end

---@param pluginName string
---@param serviceName string
---
context.registerLoadableService = function(pluginName, serviceName)
  local serviceId = getServiceId (serviceName)
  if services:hasEntry (serviceId) then
    backbone.throw ('The service "%s" is already registered.', serviceName)
  end

  services:setEntry (serviceId,  { provider = pluginName } --[[@as Backbone.Service]])
end

-- FRAMEWORK API --

---@param name string
---@return boolean
---
---Checks whether the specified service exists.
---
backbone.hasService = function (name)
  return services:hasEntry (getServiceId (name))
end

---@generic T
---
---@param name `T`
---@param ... unknown
---@return T
---
---Invokes the service with the specified name.
---
backbone.requestService = function (name, ...)
  local serviceId = getServiceId (name)
  if not services:hasEntry (serviceId) then
    backbone.throw ('The service "%s" does not exist.', name)
  end

  ---@type Backbone.Service
  local service = services:getEntry (serviceId)
  
  if service.initializer == nil then
    context.loadAddon (service.provider)
  end

  local object = service.initializer(...)
  return ((type (object) == 'table') and backbone.createImmutableProxy (object)) or object
end

-- PLUGIN API --

---@class Backbone.Plugin
local serviceAPI = context.pluginAPI

---@param name string
---@param service Backbone.ServiceInitializer
---
---Registers a service with the specified name.
---
serviceAPI.registerService = function (self, name, service)
  registerService (self, name, service)
end
