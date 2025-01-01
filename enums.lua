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

---
---Provides both abstractions of existing enumerations as well as custom ones.
---* The abstractions are provided to guard against potential future changes to the game's enumerations.
---
---@class backbone.enums
---
_G.BNUM = {}

---
---Represents anchor points for positioning UI elements.
---
---@enum ANCHOR_POINT
---
BNUM.ANCHOR_POINT =
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
---Represents the expansion levels in the game, mapping each expansion
---to its corresponding numerical identifier.
---
---@enum EXPANSION_LEVEL
---
BNUM.EXPANSION_LEVEL =
{
          CLASSIC = 0,
  BURNING_CRUSADE = 1,
        LICH_KING = 2,
        CATACLYSM = 3,
         PANDARIA = 4,
          DRAENOR = 5,
           LEGION = 6,
          AZEROTH = 7,
      SHADOWLANDS = 8,
     DRAGONFLIGHT = 9,
       WAR_WITHIN = 10
}

---
---Represents the binding types for items in the game.
---
---@enum ITEM_BIND
---
BNUM.ITEM_BIND =
{
        NONE = Enum.ItemBind.None,
  ON_ACQUIRE = Enum.ItemBind.OnAcquire,
    ON_EQUIP = Enum.ItemBind.OnEquip,
      ON_USE = Enum.ItemBind.OnUse,
       QUEST = Enum.ItemBind.Quest,
     ACCOUNT = Enum.ItemBind.ToWoWAccount,
     WARBAND = Enum.ItemBind.ToBnetAccount,
  WARBAND_EQ = Enum.ItemBind.ToBnetAccountUntilEquipped
}

---
---Represents the main categories of items in the game.
---
---@enum ITEM_CLASS
---
BNUM.ITEM_CLASS =
{
  CONSUMABLE = Enum.ItemClass.Consumable,
  CONTAINER  = Enum.ItemClass.Container,
      WEAPON = Enum.ItemClass.Weapon,
       ARMOR = Enum.ItemClass.Armor,
     REAGENT = Enum.ItemClass.Reagent,
  PROJECTILE = Enum.ItemClass.Projectile,
  TRADEGOODS = Enum.ItemClass.Tradegoods,
      RECIPE = Enum.ItemClass.Recipe,
      QUIVER = Enum.ItemClass.Quiver,
       QUEST = Enum.ItemClass.Questitem,
         KEY = Enum.ItemClass.Key,
        MISC = Enum.ItemClass.Miscellaneous,
   BATTLEPET = Enum.ItemClass.Battlepet,
   WOW_TOKEN = Enum.ItemClass.WoWToken
}

---
---Represents the quality levels of items in the game.
---
---@enum ITEM_QUALITY
---
BNUM.ITEM_QUALITY =
{
       POOR = Enum.ItemQuality.Poor,
     COMMON = Enum.ItemQuality.Common,
   UNCOMMON = Enum.ItemQuality.Uncommon,
       RARE = Enum.ItemQuality.Rare,
       EPIC = Enum.ItemQuality.Epic,
  LEGENDARY = Enum.ItemQuality.Legendary,
   ARTIFACT = Enum.ItemQuality.Artifact,
   HEIRLOOM = Enum.ItemQuality.Heirloom,
  WOW_TOKEN = Enum.ItemQuality.WoWToken
}

---
---Represents the different types of loot slots in the game.
---
---@enum LOOT_SLOT_TYPE
---
BNUM.LOOT_SLOT_TYPE =
{
      NONE = Enum.LootSlotType.None,
      ITEM = Enum.LootSlotType.Item,
     MONEY = Enum.LootSlotType.Money,
  CURRENCY = Enum.LootSlotType.Currency
}

---
---Represents the subtypes of trade skill items used in crafting professions.
---
---@enum REAGENT_TYPE
---
BNUM.REAGENT_TYPE =
{
               PARTS = 1,
       JEWELCRAFTING = 4,
               CLOTH = 5,
             LEATHER = 6,
              METALS = 7,
             COOKING = 8,
                HERB = 9,
           ELEMENTAL = 10,
               OTHER = 11,
          ENCHANTING = 12,
         INSCRIPTION = 16,
   OPTIONAL_REAGENTS = 18,
  FINISHING_REAGENTS = 19
}
