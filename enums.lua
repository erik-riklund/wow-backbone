--[[~ Updated: 2025/07/17 | Author(s): Gopher ]]
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
---A collection of enumerations used throughout the Backbone framework.
---
---These are abstractions of constants defined in the game's API,
---implemented as a safeguard against future changes.
---
---@class backbone.enums
---
backbone.enums = {}

---
---Defines anchor points for UI elements.
---
---@enum ANCHOR_POINT
---
backbone.enums.ANCHOR_POINT =
{
      TOPLEFT = 1,
     TOPRIGHT = 2,
   BOTTOMLEFT = 3,
  BOTTOMRIGHT = 4,
          TOP = 5,
       BOTTOM = 6,
         LEFT = 7,
        RIGHT = 8,
       CENTER = 9
}

---
---Represents the different expansion levels of the game.
---
---@enum EXPANSION_LEVEL
---
backbone.enums.EXPANSION_LEVEL =
{
       CLASSIC = 0, -- Vanilla
       OUTLAND = 1, -- The Burning Crusade
     NORTHREND = 2, -- Wrath of the Lich King
     CATACLYSM = 3, -- Cataclysm
      PANDARIA = 4, -- Mists of Pandaria
       DRAENOR = 5, -- Warlords of Draenor
        LEGION = 6, -- Legion
       AZEROTH = 7, -- Battle for Azeroth
   SHADOWLANDS = 8, -- Shadowlands
  DRAGONFLIGHT = 9, -- Dragonflight
    WAR_WITHIN = 10 -- The War Within
}

---
---Describes the various ways an item can bind to a player.
---
---@enum ITEM_BIND
---
backbone.enums.ITEM_BIND =
{
        NONE = Enum.ItemBind.None, -- The item is not bound to the player.
  ON_ACQUIRE = Enum.ItemBind.OnAcquire, -- Binds to the player when the item is picked up.
    ON_EQUIP = Enum.ItemBind.OnEquip, -- Binds to the player when the item is equipped.
      ON_USE = Enum.ItemBind.OnUse, -- Binds to the player when the item is used.
       QUEST = Enum.ItemBind.Quest, -- Bound to a specific quest.
     ACCOUNT = Enum.ItemBind.ToWoWAccount, -- Binds to the player's World of Warcraft account.
     WARBAND = Enum.ItemBind.ToBnetAccount, -- Binds to the player's Battle.net account.
  WARBAND_EQ = Enum.ItemBind.ToBnetAccountUntilEquipped -- Binds to the player's Battle.net account until the item is equipped.
}

---
---Categorizes different types of items in the game.
---
---@enum ITEM_TYPE
---
backbone.enums.ITEM_TYPE =
{
  CONSUMABLE = Enum.ItemClass.Consumable,
   CONTAINER = Enum.ItemClass.Container,
      WEAPON = Enum.ItemClass.Weapon,
       ARMOR = Enum.ItemClass.Armor,
  PROJECTILE = Enum.ItemClass.Projectile,
     REAGENT = Enum.ItemClass.Tradegoods, -- Tradeskill reagents.
      RECIPE = Enum.ItemClass.Recipe,
      QUIVER = Enum.ItemClass.Quiver,
       QUEST = Enum.ItemClass.Questitem,
         KEY = Enum.ItemClass.Key,
        MISC = Enum.ItemClass.Miscellaneous,
   BATTLEPET = Enum.ItemClass.Battlepet,
       TOKEN = Enum.ItemClass.WoWToken -- World of Warcraft game token.
}

---
---Defines the quality levels for items.
---
---@enum ITEM_QUALITY
---
backbone.enums.ITEM_QUALITY =
{
       POOR = Enum.ItemQuality.Poor,
     COMMON = Enum.ItemQuality.Common,
   UNCOMMON = Enum.ItemQuality.Uncommon,
       RARE = Enum.ItemQuality.Rare,
       EPIC = Enum.ItemQuality.Epic,
  LEGENDARY = Enum.ItemQuality.Legendary,
   ARTIFACT = Enum.ItemQuality.Artifact,
   HEIRLOOM = Enum.ItemQuality.Heirloom,
      TOKEN = Enum.ItemQuality.WoWToken -- World of Warcraft game token.
}

---
---Specifies the types of loot that can be obtained.
---
---@enum LOOT_TYPE
---
backbone.enums.LOOT_TYPE =
{
      NONE = Enum.LootSlotType.None,
      ITEM = Enum.LootSlotType.Item,
     MONEY = Enum.LootSlotType.Money,
  CURRENCY = Enum.LootSlotType.Currency
}

---
---Categorizes various reagent types used in professions.
---
---@enum REAGENT_TYPE
---
backbone.enums.REAGENT_TYPE =
{
       PART = 1,
      JEWEL = 4,
      CLOTH = 5,
    LEATHER = 6,
      METAL = 7,
    COOKING = 8,
       HERB = 9,
  ELEMENTAL = 10,
      OTHER = 11,
       DUST = 12,
    PIGMENT = 16,
   OPTIONAL = 18,
  FINISHING = 19
}
