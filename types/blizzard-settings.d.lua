---@meta
---@diagnostic disable: missing-return, unused-local

--[[~ Updated: 2025/01/06 | Author(s): Gopher ]]
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
---The blizzard settings API, used to interact with the configuration UI.
---
---@class blizzard.settings
---
Settings =
{
  ---
  ---Add the provided category to the configuration UI.
  ---
  ---@param category blizzard.settings.category
  ---
  RegisterAddOnCategory = function(category) end,

  ---
  ---Create a category, returning it alongside its layout.
  ---
  ---@param name string
  ---@return blizzard.settings.category category, blizzard.settings.layout layout
  ---
  RegisterVerticalLayoutCategory = function(name) end,

  ---
  ---Create a subcategory, returning it alongside its layout.
  ---
  ---@param parent blizzard.settings.category
  ---@param name string
  ---@return blizzard.settings.category category, blizzard.settings.layout layout
  ---
  RegisterVerticalLayoutSubcategory = function(parent, name) end,

  ---
  ---Create a proxy setting for the provided variable. Proxy settings allow you to
  ---control the value of a variable through custom getter and setter functions.
  ---
  ---@generic V
  ---@param category blizzard.settings.category
  ---@param variable string
  ---@param expected_type blizzard.settings.variable-type
  ---@param label string
  ---@param default_value V
  ---@param getter fun(): V
  ---@param setter fun(value: V)
  ---@return blizzard.settings.setting setting
  ---
  RegisterProxySetting = function(
      category, variable, expected_type, label, default_value, getter, setter
  )
  end,

  ---
  ---Create a checkbox, used to control a boolean setting.
  ---
  ---@param category blizzard.settings.category
  ---@param setting blizzard.settings.setting
  ---@param tooltip? string
  ---
  CreateCheckbox = function(category, setting, tooltip) end
}

---
---Represents a category within the configuration UI.
---
---@class blizzard.settings.category
---

---
---Represents the layout controller of a category.
---
---@class blizzard.settings.layout
---

---
---Represents a single setting within a category.
---
---@class blizzard.settings.setting
---

---
---Represents the data type of a variable.
---
---@alias blizzard.settings.variable-type 'boolean'|'number'|'string'
---
