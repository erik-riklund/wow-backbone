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

local panels = new 'Dictionary'

---Creates a configuration panel for the provided plugin.
---
---@param plugin Backbone.Plugin
---@return Backbone.ConfigPanel
---
backbone.createConfigPanel = function (plugin)
  if panels:hasEntry (plugin) then
    backbone.throw (
      'The plugin "%s" has already created a configuration panel.', plugin:getName()
    )
  end

  panels:setEntry (plugin, context.createConfigPanel (plugin))  
  return panels:getEntry (plugin)
end
