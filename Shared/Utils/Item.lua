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