---@diagnostic disable: duplicate-set-field

-- -------------------------------------------------------------------------- --
--                                  INVENTORY                                 --
-- -------------------------------------------------------------------------- --

---@alias DeepIterateOutput {[Guid] : DeepIterateElement}

---@class DeepIterateElement
---@field entity ItemEntity
---@field template ROOT
---@field name string
---@field statsId string
---@field tags string[]
---@field amount integer


--- Recursively iterates through an entity's inventory and all sub-inventories, building a table containing all items.
---@param entity any The entity whose inventory to iterate
---@param processedInventory? table Table to accumulate results
---@param tagFilter? table The table of tags to filter items (optional)
---@param templateFilter? table The table of templates to filter items (optional)
---@return DeepIterateOutput processedInventory Table containing all items in entity's inventory tree table format:
function DeepIterateInventory(entity, tagFilter, templateFilter, processedInventory)
    tagFilter = tagFilter or nil
    templateFilter = templateFilter or nil
    processedInventory = processedInventory or {}
    local entityInventory = entity.InventoryOwner.PrimaryInventory
    local entityItemsList = entityInventory.InventoryContainer.Items

    for _, entry in pairs(entityItemsList) do
        local item = entry.Item
        local isContainer = item.InventoryOwner ~= nil
        local StackMember = item.InventoryStackMember
        local data = {
            name = GetTranslatedString(item.DisplayName.NameKey.Handle.Handle),
            template = GUID(Osi.GetTemplate(item.Uuid and item.Uuid.EntityUuid)) or "TemplateError",
            tags = item.Tag.Tags or {},
            statsId = item.Data.StatsId or "StatsIdError",
            amount = Osi.GetStackAmount(item.Uuid and item.Uuid.EntityUuid) or 0,
            entity = item
        }
        local uuid = item.Uuid and item.Uuid.EntityUuid or nil

        -- Check if the item has all the specified tags
        if tagFilter and not Table.CheckIfAllValuesExist(data.tags, tagFilter) then
            -- Skip this item if it doesn't match all tags in the filter
            goto continue
        end

        -- Check if the item's template matches at least one of the specified templates
        if templateFilter and not Table.ContainsAny(templateFilter, data.template) then
            -- Skip this item if it doesn't match any template in the filter
            goto continue
        end

        if StackMember then
            local itemStack = StackMember.Stack.InventoryStack.Arr_u64
            for _, stackElement in pairs(itemStack) do
                local stackData = {
                    name = GetTranslatedString(stackElement.DisplayName.NameKey.Handle.Handle),
                    template = stackElement.ServerItem.Template.Id or "TemplateError",
                    tags = stackElement.Tag.Tags or {},
                    statsId = stackElement.Data.StatsId or "StatsIdError",
                    amount = Osi.GetStackAmount(stackElement.Uuid.EntityUuid) or 0,
                    entity = stackElement
                }
                local stackUuid = stackElement.Uuid and stackElement.Uuid.EntityUuid

                -- Check if the item has all the specified tags
                if tagFilter and not Table.CheckIfAllValuesExist(stackData.tags, tagFilter) then
                    -- Skip this stack item if it doesn't match all tags in the filter
                    goto continue_stack
                end

                -- Check if the item's template matches at least one of the specified templates
                if templateFilter and not Table.ContainsAny(templateFilter, stackData.template) then
                    -- Skip this stack item if it doesn't match any template in the filter
                    goto continue_stack
                end

                processedInventory[stackUuid] = stackData

                ::continue_stack::
            end
        elseif not StackMember and uuid then
            processedInventory[uuid] = data
        end

        ::continue::

        if isContainer then
            DeepIterateInventory(item, tagFilter, templateFilter, processedInventory)
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

---Give Item to each party member if they don't have it already
---@param itemTemplate ROOT
---@return boolean result true if an item was given
function GiveItemToEachPartyMember(itemTemplate)
    local hasGivenPotion = false
    GetSquadies()
    for _, player in pairs(SQUADIES) do
        if not HasItemTemplate(player, itemTemplate) then
            Osi.TemplateAddTo(itemTemplate, player, 1, 1)
            hasGivenPotion = true
        end
    end
    if hasGivenPotion then return true end
    return false
end
