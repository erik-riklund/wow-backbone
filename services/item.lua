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

local handler
local array = backbone.utils.array
local LOOT_TYPE = BNUM.LOOT_TYPE

---
---?
---
---@class backbone.item-handler
---
handler =
{
  ---
  ---Returns the id for an item.
  ---
  ---@param link string
  ---@return number
  ---
  getItemId = function(link)
    local item_id = string.match(link, 'item:(%d+)')
    return tonumber(item_id) --[[@as number]]
  end,

  ---
  ---Returns data about an item.
  ---
  ---@param item number|string
  ---@return backbone.item-data
  ---
  getItemData = function(item)
    ---
    ---Contains data about an item.
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
  ---Returns data about a loot slot.
  ---
  ---@param slot number
  ---@return backbone.loot-data
  ---
  getLootData = function(slot)
    ---
    ---Contains data about a loot slot.
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
      local cash = { string.split('\n', data.name) }
      local tracker = { gold = 0, silver = 0, copper = 0 }

      array.foreach(cash, function(_, raw_value)
        local amount, value = string.split(' ', raw_value)
        tracker[string.lower(value)] = tonumber(amount) or 0
      end)

      ---@class backbone.loot-data.money
      data.money = {
        ---@type number
        gold = tracker.gold or 0,
        ---@type number
        silver = tracker.silver or 0,
        ---@type number
        copper = tracker.copper or 0
      }
    end

    return data
  end,

  ---
  ---Determines the actual item level of an item, after any modifiers.
  ---
  ---@param item number|string
  ---@return number actual, boolean preview, number sparse
  ---
  getItemLevel = function(item)
    return C_Item.GetDetailedItemLevelInfo(item)
  end,

  ---
  ---Determine if the player knows the appearance of an item.
  ---
  ---@param item number|string
  ---@return boolean
  ---
  hasTransmog = function(item)
    return C_TransmogCollection.PlayerHasTransmogByItemInfo(item)
  end
}

---
---Register the item handler with the framework.
---
backbone.registerService('backbone.item-handler', handler)
