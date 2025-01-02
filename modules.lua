---@class __backbone
local context = select(2, ...)

---@diagnostic disable: invisible

--[[~ Updated: 2025/01/01 | Author(s): Gopher ]]
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
local traverse = backbone.utils.table.traverse

--=============================================================================
-- LOCALE HANDLER:
-- <add description of the module>
--=============================================================================

-- TODO: implement the locale handler.

--=============================================================================
-- STATE MANAGER:
--
-- This module manages saved variables for addons, ensuring consistent storage
-- and retrieval of account-wide and character-specific data. It organizes
-- variables into two scopes: account-wide (shared across characters) and
-- character-specific (unique to the current character).
--=============================================================================

---
---Responsible for initializing saved variables for addons.
---

array.insert(
  context.addon_initializers,
  ---@param addon backbone.addon
  function(addon)
    ---
    ---!
    ---
    ---@param scope 'Account'|'Character'
    ---@return table
    ---
    local createStorage = function(scope)
      local variable = string.format(
        '%s%sVariables', addon:getName(), scope
      )
      _G[variable] = _G[variable] or {}
      return _G[variable]
    end

    addon.variables = {
      account = createStorage 'Account',
      character = createStorage 'Character'
    }
  end
)

---
---Break a variable path into its components.
---
---@param path string
---@return string[]
---
local parseVariablePath = function(path)
  return { string.split('/', path) }
end

---
---Retrieve the value of a saved variable from the specified scope.
---
---@param addon backbone.addon
---@param scope 'account'|'character'
---@param key string
---@return unknown
---
local getVariable = function(addon, scope, key)
  assert(
    type(addon.variables) == 'table',
    'Saved variables are not initialized for ' .. addon:getName() .. '.'
  )
  return traverse(addon.variables[scope], parseVariablePath(key))
end

---
---Retrieve the value of a saved account variable.
---
---@param key string
---@return unknown
---
__addon.getAccountVariable = function(self, key)
  return getVariable(self, 'account', key)
end

---
---Retrieve the value of a saved character variable.
---
---@param key string
---@return unknown
---
__addon.getCharacterVariable = function(self, key)
  return getVariable(self, 'character', key)
end

---
---Set the value of a saved variable in the specified scope.
---
---@param addon backbone.addon
---@param scope 'account'|'character'
---@param key string
---@param value unknown
---
local setVariable = function(addon, scope, key, value)
  assert(
    type(addon.variables) == 'table',
    'Saved variables are not initialized for ' .. addon:getName() .. '.'
  )
  local parents = parseVariablePath(key)
  local variable = table.remove(parents)

  traverse(addon.variables[scope], parents)[variable] = value
end

---
---Set the value of a saved account variable.
---
---@param key string
---@param value unknown
---
__addon.setAccountVariable = function(self, key, value)
  setVariable(self, 'account', key, value)
end

---
---Set the value of a saved character variable.
---
---@param key string
---@param value unknown
---
__addon.setCharacterVariable = function(self, key, value)
  setVariable(self, 'character', key, value)
end

--=============================================================================
-- SERVICE MANAGER:
--
-- This module manages the registration and retrieval of services within the
-- Backbone framework. Services are shared components that provide reusable
-- functionality and can be accessed by multiple addons.
--=============================================================================

local services = ({} --[[@as table<string, backbone.service>]])
local getServiceId = function(name) return string.lower(name) end

---
---Register a service with the specified name and object.
---
---@param service_name string
---@param object backbone.service-object
---
backbone.registerService = function(service_name, object)
  local service_id = getServiceId(service_name)
  if dictionary.has(services, service_id) then
    local service = dictionary.get(services, service_id)
    assert(
      service.object == nil,
      'The service "' .. service_name .. '" is already registered.'
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
    dictionary.has(services, service_id),
    'The requested service "' .. service_name .. '" does not exist.'
  )
  local protect = backbone.utils.table.protect
  local service = dictionary.get(services, service_id)

  if service.object == nil then
    C_AddOns.LoadAddOn(service.supplier --[[@as string]])
    while service.object == nil do
      -- defer execution until the addon is loaded.
    end
  end

  return protect(service.object)
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
    not dictionary.has(services, service_id),
    'The ervice "' .. service_name .. '" already exists.'
  )
  dictionary.set(services, service_id, { supplier = addon_name, })
end

--=============================================================================
-- ADDON LOADER:
--
-- This module handles the conditional loading of addons based on specific
-- triggers such as game events or service requests. It ensures addons are
-- loaded only when required, optimizing performance and resource usage.
--=============================================================================

---
---Break down a metadata string into its component parts.
---
---@param metadata string
---@return string[]
---
local parseAddonMetadata = function(metadata)
  local data = { string.split(',', metadata) }
  array.foreach(data, function(_, value) return string.trim(value) end)

  return data
end

---
---The available handlers for loading addons.
---
---@type table<string, fun(index: number, metadata: string)>
---
local load_handlers =
{
  ---
  ---Responsible for loading addons on specific events.
  ---
  OnEvent = function(index, metadata)
    array.foreach(
      parseAddonMetadata(metadata), function(_, event_name)
        backbone.registerEventListenerOnce(
          event_name, function()
            if not C_AddOns.IsAddOnLoaded(index) then
              C_AddOns.LoadAddOn(index)
            end
          end
        )
      end
    )
  end,

  ---
  ---Responsible for loading addons on service requests.
  ---
  OnServiceRequest = function(index, metadata)
    local addon_name = C_AddOns.GetAddOnInfo(index)
    array.foreach(
      parseAddonMetadata(metadata), function(_, service_name)
        context.registerLoadableService(addon_name, service_name)
      end
    )
  end
}

---
---Apply load handlers for addons that should be conditionally loaded.
---
for index = 1, C_AddOns.GetNumAddOns() do
  if C_AddOns.IsAddOnLoadOnDemand(index) then
    dictionary.foreach(
      load_handlers, function(name, handler)
        local metadata = C_AddOns.GetAddOnMetadata(index, 'X-Load-' .. name)
        if type(metadata) == 'string' and #metadata > 0 then
          handler(index, metadata)
        end
      end
    )
  end
end
