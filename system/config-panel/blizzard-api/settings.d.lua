---@meta

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

---@class Settings
Settings = {}

---@class Settings.Default
Settings.Default = { True = true, False = false }

---@class Settings.VarType
Settings.VarType = { Boolean = 'boolean', Number = 'number', String = 'string' }

---@param category Settings.VerticalLayoutCategory
---@param setting table
---@param tooltip? string
---
Settings.CreateCheckbox = function (category, setting, tooltip) end

---@param category Settings.VerticalLayoutCategory
---
Settings.RegisterAddOnCategory = function (category) end

---@param name string
---@return Settings.VerticalLayoutCategory category, Settings.VerticalLayout layout
---
Settings.RegisterVerticalLayoutCategory = function (name) end

---@param parent Settings.VerticalLayoutCategory
---@param name string
---
---@return Settings.VerticalLayoutCategory category, Settings.VerticalLayout layout
---
Settings.RegisterVerticalLayoutSubcategory = function (parent, name) end

---@generic T
---
---@param category Settings.VerticalLayoutCategory
---@param variable string
---@param variableType `T`
---@param name string
---@param defaultValue T
---@param getter fun(): T
---@param setter fun(value: T)
---
---@return table setting
---
Settings.RegisterProxySetting = function (category, variable, variableType, name, defaultValue, getter, setter) end

---@param text string
---@param tooltip? string
---
---@return table header
---
CreateSettingsListSectionHeaderInitializer = function (text, tooltip) end

