---@class __backbone
local context = select(2, ...)

---@diagnostic disable: invisible

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

---@class backbone.addon
local __addon = context.__addon

local dictionary = backbone.utils.dictionary
local protect = backbone.utils.table.protect

--=============================================================================
-- SERVICE MANAGER:
--
-- This module manages the registration and retrieval of services within the
-- Backbone framework. Services are shared components that provide reusable
-- functionality and can be accessed by multiple addons.
--=============================================================================

local services = ({} --[[@as table<string, backbone.service>]])
local service_cache = setmetatable({}, { __mode = 'v' }) --[[@as table<string, backbone.service-object>]]
local getServiceId = function(name) return string.lower(name) end

---
---Register a service with the specified name and associated object.
---
---@param service_name string
---@param object backbone.service-object
---
backbone.registerService = function(service_name, object)
  local service_id = getServiceId(service_name)
  if dictionary.has(services, service_id) then
    local service = services[service_id]
    assert(
      service.object == nil, string.format(
        'The service "%s" is already registered.', service_name
      )
    )
    service.object = object
  else
    dictionary.set(services, service_id, { object = object })
  end
end

---
---Retrieve a service object by its name.
---
---@generic T
---@param service_name `T`
---@return T
---
backbone.requestService = function(service_name)
  local service_id = getServiceId(service_name)
  assert(
    dictionary.has(services, service_id), string.format(
      'The requested service "%s" does not exist.', service_name
    )
  )

  local service = services[service_id]
  if service.object == nil then
    C_AddOns.LoadAddOn(service.supplier --[[@as string]])
    while service.object == nil do
      -- defer execution until the addon is loaded.
    end
  end

  local proxy = service_cache[service_id]
  if proxy == nil then
    proxy = protect(service.object --[[@as backbone.service-object]])
    dictionary.set(service_cache, service_id, proxy)
  end
  return proxy
end

---
---Used internally to register loadable services.
---
---@param addon_name string
---@param service_name string
---
context.registerLoadableService = function(addon_name, service_name)
  local service_id = getServiceId(service_name)
  assert(
    not dictionary.has(services, service_id), string.format(
      'The service "%s" already exists.', service_name
    )
  )
  dictionary.set(services, service_id, { supplier = addon_name, })
end
