---@class Backbone
local context = select(2, ...)

--[[~ Updated: 2024/12/09 | Author(s): Gopher ]]

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

context.plugin:registerDefaultSettings { DEVELOPMENT_MODE = false }

context.plugin:onReady (
  function ()
    -- local configPanel = ConfigPanel (context.plugin)

    -- configPanel:createToggle { 
    --   setting = 'DEVELOPMENT_MODE', label = 'development-mode', tooltip = true
    --  }
  end
)
