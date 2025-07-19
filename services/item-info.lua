--[[~ Updated: 2025/07/18 | Author(s): Gopher ]]
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

local handler
local LOOT_TYPE = backbone.enums.LOOT_TYPE

---
---A service object for retrieving information about items and loot.
---
---@class backbone.item-info : backbone.service-object
---
handler =
{
  ---
  ---Retrieves the item ID from an item link.
  ---
  ---@param link string
  ---@return number id
  ---
  getItemId = function(link)
    local itemId = string.match(link, 'item:(%d+)')
    return tonumber(itemId) --[[@as number]]
  end,

  ---
  ---Retrieves information about an item, based on its item link or ID.
  ---
  ---@param item number|string
  ---@return backbone.item-data
  ---
  getItemData = function(item)
    ---
    ---@class backbone.item-data
    ---
    local data = {}

    data.name,
    data.link,
    data.quality,
    data.baseItemLevel,
    data.requiredPlayerLevel,
    data.localizedType,
    data.localizedSubtype,
    data.stackCount,
    data.equipLocation,
    data.textureId,
    data.sellPrice,
    data.typeId,
    data.subtypeId,
    data.bindType,
    data.expansionId,
    data.setId,
    data.isCraftingReagent = C_Item.GetItemInfo(item)

    if data.link ~= nil then
      data.id = handler.getItemId(data.link)
      data.itemLevel = handler.getItemLevel(data.link)
    end

    return data
  end,

  ---
  ---Retrieves information about a loot slot.
  ---
  ---@param slot number
  ---@return backbone.loot-data
  ---
  getLootData = function(slot)
    ---
    ---@class backbone.loot-data
    ---
    local data = {}

    data.icon,
    data.name,
    data.quantity,
    data.currencyId,
    data.quality,
    data.isLocked,
    data.isQuestItem,
    data.questId,
    data.isQuestActive = GetLootSlotInfo(slot)

    data.slotType = GetLootSlotType(slot)
    data.itemLink = GetLootSlotLink(slot)

    if data.slotType == LOOT_TYPE.MONEY then
      ---
      ---@class backbone.loot-data.money
      ---
      ---@field gold number
      ---@field silver number
      ---@field copper number
      ---
      data.money = { gold = 0, silver = 0, copper = 0 }
      local cash = { string.split('\n', data.name) }

      array.iterate(cash,
        function(_, rawValue)
          local amount, value = string.split(' ', rawValue)
          data.money[string.lower(value)] = tonumber(amount) or 0
        end
      )
    end

    return data
  end,

  ---
  ---Retrieves the item level of an item.
  ---
  ---@param item number|string
  ---@return number actual, boolean preview, number sparse
  ---
  getItemLevel = function(item)
    return C_Item.GetDetailedItemLevelInfo(item)
  end,

  ---
  ---Determines if the player knows the appearance of an item.
  ---
  ---@param item number|string
  ---@return boolean
  ---
  hasTransmog = function(item)
    return C_TransmogCollection.PlayerHasTransmogByItemInfo(item)
  end
}

backbone.registerService('backbone.item-info', handler)
