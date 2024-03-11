---@diagnostic disable: duplicate-set-field

---@alias DeepIterateFilter function |"FilterByTag"|"FilterByTemplate"

---@alias FilterMode string |"all"|"any"

---@alias DeepIterateOutput {[Guid] : DeepIterateElement}

---@class DeepIterateElement
---@field entity ItemEntity
---@field template ROOT
---@field name string
---@field statsId string
---@field tags string[]
---@field amount integer

-- -------------------------------------------------------------------------- --
--                                  INVENTORY                                 --
-- -------------------------------------------------------------------------- --

---format our inv element
---@param itemEntity ItemEntity
---@return DeepIterateElement
local function formatInventoryObjectData(itemEntity)
    local uuid = itemEntity.Uuid and itemEntity.Uuid.EntityUuid
    if not uuid then uuid = NULLUUID end
    local data={
        name = GetTranslatedString(SafeGetField(itemEntity,"DisplayName.NameKey.Handle.Handle")),
        template = GUID(Osi.GetTemplate(uuid)) or "TemplateError",
        tags = SafeGetField(itemEntity,"Tag.Tags") or {},
        statsId = SafeGetField(itemEntity,"Data.StatsId") or "StatsIdError",
        amount = Osi.GetStackAmount(uuid) or 0,
        entity = itemEntity
    }
    return data
end

---Filter by tag for deepiterate
---@param filter table table of tags
---@param filterMode? FilterMode filtering mode, any or all matches, defaults to all for tags
function FilterByTag(filter, filterMode)
    ---@param data DeepIterateElement
    return function(data)
        filterMode = filterMode or "all"

        if filterMode == "all" then
            if Table.CheckIfAllValuesExist(data.tags, filter) then
                return data
            else
                return nil
            end
        elseif filterMode == "any" then
            --write it
        end
    end
end

---Filter by template for deepiterate
---@param filter table table of templates
---@param filterMode? FilterMode filtering mode, any or all matches, defaults to any for templates
function FilterByTemplate(filter, filterMode)
    ---@param data DeepIterateElement
    return function(data)
        filterMode = filterMode or "any"

        if filterMode == "all" then
            --write it
        elseif filterMode == "any" then
            if Table.ContainsAny(filter, data.template) then
                return data
            else
                return nil
            end
        end
    end
end

--- Recursively iterates through an entity's inventory and all sub-inventories, building a table containing all items.
---@param entity Entity The entity whose inventory to iterate
---@param processedInventory? table Table to accumulate results
---@param filterFuncs? DeepIterateFilter[] the filtering function
---@return DeepIterateOutput processedInventory Table containing all items in entity's inventory tree table format:
function DeepIterateInventory(entity, filterFuncs, processedInventory)
    processedInventory = processedInventory or {}
    local entityInventory = entity.InventoryOwner.PrimaryInventory
---@diagnostic disable-next-line: undefined-field
    local entityItemsList = entityInventory.InventoryContainer.Items
    for _, entry in pairs(entityItemsList) do
        local item = entry.Item
        local isContainer = item.InventoryOwner ~= nil
        local StackMember = item.InventoryStackMember
        local data = formatInventoryObjectData(item)
        local uuid = item.Uuid and item.Uuid.EntityUuid or nil
        if filterFuncs then
            for _, func in ipairs(filterFuncs) do
                data = func(data)
            end
        end
        if StackMember and data then
            local itemStack = StackMember.Stack.InventoryStack.Arr_u64
            for _, stackElement in pairs(itemStack) do
                local stackData = formatInventoryObjectData(stackElement)
                local stackUuid = stackElement.Uuid and stackElement.Uuid.EntityUuid
                processedInventory[stackUuid] = stackData
            end
        elseif not StackMember and uuid and data then
            processedInventory[uuid] = data
        end

        if isContainer then
            DeepIterateInventory(item, filterFuncs, processedInventory)
        end
    end
    return processedInventory
end

---Check if a character has an item by template
---@param character CHARACTER
---@param root ROOT
---@return boolean
function HasItemTemplate(character, root)
    return Osi.TemplateIsInInventory(root, character) >= 1
end


---@param itemTemplate ROOT
---@param onetime? boolean
---@param varToCheck? string
---@return boolean result true if an item was given
function GiveItemToEachPartyMember(itemTemplate,onetime,varToCheck)
    onetime=onetime or false
    varToCheck = varToCheck or nil
    if not onetime then
        local hasGivenItem = false
        GetSquadies()
        for _, player in pairs(SQUADIES) do
            if not HasItemTemplate(player, itemTemplate) then
                Osi.TemplateAddTo(itemTemplate, player, 1, 1)
                hasGivenItem = true
            end
        end
        return hasGivenItem
    else
        local modVars = GetModVariables()
        local hasGivenItem = false
        GetSquadies()
        for _, player in pairs(SQUADIES) do
            if varToCheck and not modVars[varToCheck] then
                modVars[varToCheck] = {}
            end
            
            if not modVars[varToCheck][player] then
                modVars[varToCheck][player] = {}
            end
        
            -- Now you can safely access modVars[varToCheck][player]
            local playerModVar = modVars[varToCheck][player]
            if not HasItemTemplate(player, itemTemplate) or playerModVar[itemTemplate] then
                Osi.TemplateAddTo(itemTemplate, player, 1, 1)
                modVars[varToCheck][player][itemTemplate]=true
                BasicDebug("Doot")
                hasGivenItem = true
            end
        end
        SyncModVariables()
        return hasGivenItem
    end
end


