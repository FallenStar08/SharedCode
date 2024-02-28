---Add X amount of resource Y
---@param entity Entity
---@param resourceGuid GUIDSTRING
---@param amountToAdd integer
---@param subResource? integer
function AddActionResource(entity, resourceGuid, amountToAdd, subResource)
    if entity and entity.ActionResources and entity.ActionResources.Resources and entity.ActionResources.Resources[resourceGuid] then
        subResource = subResource or 1
        local currentAmount = entity.ActionResources.Resources[resourceGuid][subResource].Amount
        local maxAmount = entity.ActionResources.Resources[resourceGuid][subResource].MaxAmount
        currentAmount = math.max(currentAmount + amountToAdd, maxAmount)
        entity.ActionResources.Resources[resourceGuid][subResource].Amount=currentAmount
        entity:Replicate("ActionResources")
    else
        --Ideally log an error or something, pretty sure it'll throw an error if entity doesn't have ActionResources anyway
        return
    end
end

---Remove X amount of resource Y
---@param entity Entity
---@param resourceGuid GUIDSTRING
---@param amountToRemove integer
---@param subResource? integer
function RemoveActionResource(entity, resourceGuid, amountToRemove, subResource)
    if entity and entity.ActionResources and entity.ActionResources.Resources and entity.ActionResources.Resources[resourceGuid] then
        subResource = subResource or 1
        local currentAmount = entity.ActionResources.Resources[resourceGuid][subResource].Amount
        currentAmount = math.max(currentAmount - amountToRemove, 0)
        entity.ActionResources.Resources[resourceGuid][subResource].Amount=currentAmount
        entity:Replicate("ActionResources")
    else
        --Ideally log an error or something, pretty sure it'll throw an error if entity doesn't have ActionResources anyway
        return
    end
end


---Recover max amount of resource X
---@param entity Entity
---@param resourceGuid GUIDSTRING
---@param subResource? integer
function RefillActionResource(entity, resourceGuid, subResource)
    if entity and entity.ActionResources and entity.ActionResources.Resources and entity.ActionResources.Resources[resourceGuid] then
        subResource = subResource or 1
        local maxAmount = entity.ActionResources.Resources[resourceGuid][subResource].MaxAmount
        AddActionResource(entity, resourceGuid, maxAmount, subResource)
    else
        return
    end
end

---Remove max amount of resource X
---@param entity Entity
---@param resourceGuid GUIDSTRING
---@param subResource? integer
function EmptyActionResource(entity, resourceGuid, subResource)
    if entity and entity.ActionResources and entity.ActionResources.Resources and entity.ActionResources.Resources[resourceGuid] then
        subResource = subResource or 1
        local maxAmount = entity.ActionResources.Resources[resourceGuid][subResource].MaxAmount
        RemoveActionResource(entity, resourceGuid, maxAmount, subResource)
    else
        return
    end
end
