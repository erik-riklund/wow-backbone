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

context.registerAddonLoader (
  function (addonIndex)
    local events = context.getAddonMetadata (
      addonIndex, 'X-Load-OnEvent'
    )

    if type (events) == 'string' then
      local eventList = backbone.splitString (events, ',')

      eventList:forEach(
        ---@param eventName string
        function (_, eventName)
          context.plugin:registerEventListener(
            eventName, {
              callback = function () context.loadAddon (addonIndex) end,
              identifier = string.format ('X-Load-OnEvent/%s/%s', eventName, addonIndex),
            }
          )
        end
      )
    end
  end
)
