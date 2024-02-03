---Add amount of gold to a character
---@param character string character uuid
---@param amount integer the amount of gold to add
function AddGoldTo(character, amount)
    Osi.TemplateAddTo(GOLD, character, amount)
end

---Remove amount of gold from a character
---@param character string character uuid
---@param amount integer the amount of gold to remove
function RemoveGoldFrom(character, amount)
    Osi.TemplateRemoveFrom(GOLD, character, amount)
end

---Check if item is (probably) quest related
---@param item GUIDSTRING|ItemEntity
---@return boolean
function IsProbablyQuestItem(item)

    if type(item=="string") then
        ---@cast item string
        return Osi.IsStoryItem(item) == 1 and StringContains(Osi.GetStatString(item), "quest") and StringContains(Template.GetTemplate(item).Name,"quest")
    else
        ---@cast item ItemEntity
        local uuid = EntityToUuid(item) or NULLUUID
        return Osi.IsStoryItem(uuid) == 1 and StringContains(item.Data.StatsId, "quest") and StringContains(item.ServerItem.Template.Name,"quest")
    end
end