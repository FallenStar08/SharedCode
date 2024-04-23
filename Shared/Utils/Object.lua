---@param uuid Guid
---@return table tags
function GetTags(uuid)
    local tags = {}
    local entity = _GE(uuid)
    local entityTags = (entity and entity.Tag) and entity.Tag.Tags
    if entityTags then
        for _, tag in pairs(entityTags) do
            local tagData = Ext.StaticData.Get(tag, "Tag")
            if tagData ~= nil then
                tags[tagData.Name] = tag
            end
        end
    end
    return tags
end
