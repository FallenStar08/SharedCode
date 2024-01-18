---@diagnostic disable: duplicate-set-field

Treasure = {}

-- -------------------------------------------------------------------------- --
--                                  Treasures                                 --
-- -------------------------------------------------------------------------- --

---Retrieves the treasure table associated with the specified name.
---@param treasureTableName (string) The name of the treasure table to retrieve.
---@return table? TreasureTable treasure table associated with the specified name, or nil if not found.
function Treasure.GetTT(treasureTableName)
    return Ext.Stats.TreasureTable.GetLegacy(treasureTableName)
end

--- Retrieves the items contained in the specified treasure category.
---@param treasureCategoryName string The name of the treasure category to retrieve.
---@return table? TreasureCategory items contained in the specified treasure category, or nil if not found.
function Treasure.GetTC(treasureCategoryName)
    return Ext.Stats.TreasureCategory.GetLegacy(treasureCategoryName)
end

--- Generate items from a treasure table
--- Written by focus, yoinked
---@param treasureTable string Name of the TT
---@param target? string Who to give the content to
---@param level? integer level to use for the TT loot generation
---@param finder? string idk
---@param generateInBag? boolean if true will put the content into a bag
function Treasure.GenerateTreasureTable(treasureTable, target, level, finder, generateInBag)
    local bag = generateInBag ~= false and Osi.CreateAt(POUCH, 0, 0, 0, 0, 0, "")
    target = target or Osi.GetHostCharacter()

    if level == nil then
        if Osi.IsItem(target) == 1 then
            level = -1
        else
            level = Osi.GetLevel(target)
        end
    end

    if finder == nil then
        if Osi.IsItem(target) == 1 then
            finder = Osi.GetHostCharacter()
        else
            finder = target
        end
    end

    if bag then
        Osi.GenerateTreasure(bag, treasureTable, level, finder)
        Osi.ToInventory(bag, target)
    else
        Osi.GenerateTreasure(target, treasureTable, level, finder)
    end
end