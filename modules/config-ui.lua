---@class __backbone
local context = select(2, ...)

---@diagnostic disable: invisible

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

local dictionary = backbone.utils.dictionary
local panels = ({} --[[@as table<backbone.addon, backbone.config-ui.panel>]])

---
---!
---
---@param name string
---@return string
---
local getCategoryId = function(name)
  return string.lower(name)
end

---
---?
---
---@class backbone.config-ui.category
---@field protected owner backbone.addon
---@field protected object blizzard.settings.category
---@field protected layout blizzard.settings.layout
---
local configurationUserInterfaceCategory =
{
  ---
  ---?
  ---
  ---@protected
  ---@param self backbone.config-ui.category
  ---@return backbone.config-ui.category
  ---
  new = function(self)
    ---@diagnostic disable-next-line: missing-return
  end
}

---
---?
---
---@class backbone.config-ui.panel : backbone.config-ui.category
---@field private categories table<string, backbone.config-ui.category>
---
local configurationUserInterfacePanel =
{
  ---
  ---?
  ---
  ---@private
  ---@param self backbone.config-ui.panel
  ---@param owner backbone.addon
  ---@param label? string
  ---@return backbone.config-ui.panel
  ---
  new = function(self, owner, label)
    local object, layout = Settings.RegisterVerticalLayoutCategory(label or owner:getName())
    local instance = { owner = owner, object = object, layout = layout, categories = {} }
    return setmetatable(instance, { __index = self }) --[[@as backbone.config-ui.panel]]
  end
}

setmetatable(
  configurationUserInterfacePanel, { __index = configurationUserInterfaceCategory }
)

---
---?
---
---@param addon backbone.addon
---@param label? string
---@return backbone.config-ui.panel
---
backbone.createConfigurationPanel = function(addon, label)
  assert(
    context.getAddon(addon:getName()) == addon,
    'Expected argument `addon` to be a registered addon.'
  )
  assert(
    label == nil or (type(label) == 'string' and string.len(label) > 0),
    'Expected argument `label` to be a non-empty string.'
  )
  assert(
    not dictionary.has(panels, addon), string.format(
      'The configuration panel for the addon "%s" has already been created.', addon:getName()
    )
  )

  return dictionary.set(
    panels, addon, configurationUserInterfacePanel:new(addon, label)
  )
end
