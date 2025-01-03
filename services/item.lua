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
  getItemId = function(link)
    return link:match 'item:(%d+)'
  end,

  ---
  ---Returns detailed information about an item.
  ---
  ---@param item number|string
  ---@return backbone.item-data
  ---
  getItemInfo = function(item)
    ---
    ---Contains detailed information about an item.
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
  ---Returns detailed information about a loot slot.
  ---
  ---@param slot number
  ---@return backbone.loot-data
  ---
  getLootInfo = function(slot)
    ---
    ---Contains detailed information about a loot slot.
    ---
    ---@class backbone.loot-data
    ---
    local data = {}

    data.icon,
    data.name,
    data.quantity,
    data.currencyId,
    data.quality,
    data.locked,
    data.isQuestItem,
    data.questId,
    data.isQuestActive = GetLootSlotInfo(slot)

    data.slotType = GetLootSlotType(slot)
    data.itemLink = GetLootSlotLink(slot)

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
  end
}

---
---Register the item handler with the framework.
---
backbone.registerService('backbone.item-handler', handler)
