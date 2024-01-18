---@diagnostic disable: duplicate-set-field

-- -------------------------------------------------------------------------- --
--                                  INVENTORY                                 --
-- -------------------------------------------------------------------------- --

--- Recursively iterates through an entity's inventory and all sub-inventories, building a table containing all items.
---@param entity any The entity whose inventory to iterate
---@param processedInventory? table Table to accumulate results
---@param tagFilter? table The table of tags to filter items (optional)
---@return table processedInventory Table containing all items in entity's inventory tree table format: 
---["uuid"]={amount(int), statsId(str), tags(table), template(str)}
function DeepIterateInventory(entity, tagFilter, processedInventory)
    tagFilter = tagFilter or nil
    processedInventory = processedInventory or {}
    local entityInventory = entity.InventoryOwner.PrimaryInventory
    local entityItemsList = entityInventory.InventoryContainer.Items

    for _, entry in pairs(entityItemsList) do
        local item = entry.Item
        local isContainer = item.InventoryOwner ~= nil
        local StackMember = item.InventoryStackMember
        local data = {
            template = Osi.GetTemplate(item.Uuid and item.Uuid.EntityUuid) or "TemplateError",
            tags = item.Tag.Tags or {},
            statsId = item.Data.StatsId or "StatsIdError",
            amount = Osi.GetStackAmount(item.Uuid.EntityUuid) or 0
        }
        local uuid = item.Uuid and item.Uuid.EntityUuid or nil

        -- Check if the item has all the specified tags
        if tagFilter and not Table.CheckIfAllValuesExist(data.tags, tagFilter) then
            -- Skip this item if it doesn't match all tags in the filter
            goto continue
        end

        if StackMember then
            local itemStack = StackMember.Stack.InventoryStack.Arr_u64
            for _, stackElement in pairs(itemStack) do
                local stackData = {
                    template = stackElement.ServerItem.Template.Id or "TemplateError",
                    tags = stackElement.Tag.Tags or {},
                    statsId = stackElement.Data.StatsId or "StatsIdError",
                    amount = Osi.GetStackAmount(stackElement.Uuid.EntityUuid) or "AmountError"
                }
                local stackUuid = stackElement.Uuid and stackElement.Uuid.EntityUuid

                -- Check if the item has all the specified tags
                if tagFilter and not Table.CheckIfAllValuesExist(stackData.tags, tagFilter) then
                    -- Skip this stack item if it doesn't match all tags in the filter
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
            DeepIterateInventory(item, tagFilter, processedInventory)
        end
    end

    return processedInventory
end


function HasItemTemplate(character,root )
    if Osi.TemplateIsInInventory(root, character) >= 1 then
        return true
    else
        return false
    end
end