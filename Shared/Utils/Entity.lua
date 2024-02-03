-- -------------------------------------------------------------------------- --
--                               Entities stuff                               --
-- -------------------------------------------------------------------------- --
---comment
---@param entity ItemEntity|CharacterEntity
---@return Guid|nil
function EntityToUuid(entity)
    return Ext.Entity.HandleToUuid(entity)
end
---comment
---@param uuid Guid
---@return Entity
function _GE(uuid)
    return Ext.Entity.Get(uuid)
end

--- Retrieves entities uuid with a specified component within a given distance from a reference object.

---@param fromObject? string The reference object from which to measure distances. If nil, the host character is used.
---@param component ExtComponentType The name of the component to check for in entities.
---@param maxDistance? number The maximum distance within which entities should be considered. If nil, Defaults to 10
---@param minDistance? number The minimum distance within which entities should be considered. If nil, Defaults to 0
---@return table results A table containing information about entities within the specified distance and with the specified component.
--- Each entry in the table is a table with the following fields:
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
        local uuid = v.Uuid.EntityUuid
        local distance = Osi.GetDistanceTo(fromObject, uuid)
        if not distance then
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


