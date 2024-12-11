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

context.plugin:registerLocalizedStrings (
  'enUS', {
    ['development-mode'] = 'Development mode',
    ['development-mode-tooltip'] = 'Allows for adapting the behavior of addons depending on the current environment.',

    ['item-quality/poor']      = 'Poor',
    ['item-quality/common']    = 'Common',
    ['item-quality/uncommon']  = 'Uncommon',
    ['item-quality/rare']      = 'Rare',
    ['item-quality/epic']      = 'Epic',
    ['item-quality/legendary'] = 'Legendary',
    ['item-quality/artifact']  = 'Artifact',
    ['item-quality/heirloom']  = 'Heirloom',
  }
)
