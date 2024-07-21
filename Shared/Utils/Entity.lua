-- -------------------------------------------------------------------------- --
--                               Entities stuff                               --
-- -------------------------------------------------------------------------- --
---returns the entity's uuid
---@param entity EntityHandle|Entity
---@return Guid|nil
function EntityToUuid(entity)
    return Ext.Entity.HandleToUuid(entity)
end

---shortcut for Ext.Entity.Get(uuid)
---@param uuid Guid
---@return Entity?
function _GE(uuid)
    if uuid then
        return Ext.Entity.Get(uuid)
    else
        return nil
    end
end

--- Retrieves entities uuid with a specified component within a given distance from a reference object.

---@param fromObject? string The reference object from which to measure distances. If nil, the host character is used.
---@param component ExtComponentType The name of the component to check for in entities.
---@param maxDistance? number The maximum distance within which entities should be considered. If nil, Defaults to 10
---@param minDistance? number The minimum distance within which entities should be considered. If nil, Defaults to 0
---@return table results A table containing information about entities within the specified distance and with the specified component.
--- Each entry in the table is a table with the following fields: --TODO make class for result table
---   - Name (string) The translated name of the entity.
---   - UUID (string) The UUID of the entity.
---   - distance (number) The distance from the reference object to the entity.
---   - inventory (boolean) Indicates if the entity is in the inventory (true) or not (false).
function GetClosestEntitiesFromObjectByComponent(fromObject, component, minDistance, maxDistance)
    local results = {}
    fromObject = fromObject or Osi.GetHostCharacter()
    minDistance = minDistance or 0
    maxDistance = maxDistance or 10
    local allEntities = Ext.Entity.GetAllEntitiesWithComponent(component)
    for i, v in ipairs(allEntities) do
        local isInInventory = false
        local uuid = EntityToUuid(v) or NULLUUID
        local distance = Osi.GetDistanceTo(fromObject, uuid)
        if not distance then
            --Only if the fromObject was someone with an inventory actually, idk
            isInInventory = true
            distance = 0
        end
        if distance <= maxDistance and distance >= minDistance then
            table.insert(results,
                { Name = GetTranslatedName(uuid), UUID = uuid, distance = distance, inventory = isInInventory })
        end
    end
    return results
end

---Copy data from donor entity to target entity
---@param TargetEntity Entity the entity that'll receive data from the donor
---@param DonorEntity Entity the donor entity that splurge his data onto the target
---@param copyList table the list of components to copy from donor to target
function CopyEntityData(TargetEntity, DonorEntity, copyList)
    if TargetEntity and DonorEntity then
        for _, entry in ipairs(copyList) do
            CopyComponentData(TargetEntity[entry], DonorEntity[entry])
            TargetEntity:Replicate(entry)
        end
    else
        BasicError("CopyEntityData() Error here")
    end
end

---Try to copy component data from donor to target using serialize
---@param target BaseComponent component that'll be overwritten
---@param donor BaseComponent component that'll give its juicy data
function CopyComponentData(target, donor)
    local success, errorOrSerialized = pcall(Ext.Types.Serialize, donor)
    if success then
        local success2, _ = pcall(Ext.Types.Unserialize, target, errorOrSerialized)
        if not success2 then
            --dontcare+yourecringe
        end
    else
        --dontcare+yourecringe
    end
end

---Nuke all statuses on an entity
--TODO fix this shit and make it work on characters
---@param Entity Entity
function ClearAllStatuses(Entity)
    if Entity and Entity.ServerItem and Entity.ServerItem.StatusManager then
        for index, data in ipairs(Entity.ServerItem.StatusManager.Statuses) do
            Entity.ServerItem.StatusManager.Statuses[index] = nil
        end
    end
end

---Copy statuses from one entity to another, clear statuses from target beforehand
---@param TargetEntity Entity status will be applied to this entity
--TODO fix this shit and make it work on characters
---@param DonorEntity Entity statuses will come from this entity
function CopyStatuses(TargetEntity, DonorEntity)
    local targetUuid = EntityToUuid(TargetEntity)
    ClearAllStatuses(TargetEntity)
    if targetUuid and DonorEntity and DonorEntity.ServerItem then
        for i = 1, #DonorEntity.ServerItem.StatusManager.Statuses do
            Osi.ApplyStatus(targetUuid, DonorEntity.ServerItem.StatusManager.Statuses[i].StatusId, -1)
        end
    else
        BasicWarning("CopyStatuses() TargetEntity has no Uuid! Retrying...")
        TEMPsubId = Ext.Entity.Subscribe("StatusContainer", function(entity, component, flag)
            CopyStatuses(TargetEntity, DonorEntity)

            Ext.Entity.Unsubscribe(TEMPsubId)
        end, TargetEntity)
    end
end

---Returns a list of statuses applied on the target entity
---@param Entity Entity?
---@return table<string,boolean>
function GetAppliedStatus(Entity)
    if not Entity then return {} end
    local statuses = {}
    local entitiesStatus = SafeGetField(Entity, "StatusContainer.Statuses")
    if entitiesStatus then
        for statusEntity, statusName in pairs(Entity.StatusContainer.Statuses) do
            statuses[statusName] = true
        end
    end
    return statuses
end

---Check if target entity is affected by a given status
---@param Entity Entity
---@param statusName string
---@return boolean
function HasStatus(Entity, statusName)
    local statuses = GetAppliedStatus(Entity)
    if statuses[statusName] then
        return true
    end
    return false
end
