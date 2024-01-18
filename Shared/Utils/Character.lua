---Check if a character is transformed or not
---@param character string
---@return boolean isTransformed true if the character is transformed
---@return string GUID either the character uuid if not transformed or the template of the transformation if it is
function IsTransformed(character)
    local entity = Ext.Entity.Get(character)
    local transfoUUID = ""
    local charUUID = ""
    local rootTemplateType = entity.GameObjectVisual.RootTemplateType or 1
    if entity and entity.GameObjectVisual then
        transfoUUID = entity.GameObjectVisual.RootTemplateId
    end
    if entity and entity.Uuid then
        charUUID = entity.Uuid.EntityUuid
    end
    if transfoUUID == charUUID or rootTemplateType == 1 then
        BasicDebug("IsTransformed() False - ")
        BasicDebug({ transfoUUID = transfoUUID, charUUID = charUUID })
        return false, charUUID
    else
        BasicDebug("IsTransformed() True - ")
        BasicDebug({ transfoUUID = transfoUUID, charUUID = charUUID })
        return true, transfoUUID
    end
end

---Destroy a character
---@param character string the uuid of the character to destroy
function DestroyChar(character)
    Osi.PROC_RemoveAllPolymorphs(character)
    Osi.PROC_RemoveAllDialogEntriesForSpeaker(character)
    Osi.SetImmortal(character, 0)
    Osi.Die(character, 2, "NULL_00000000-0000-0000-0000-000000000000", 0, 0)
    BasicDebug("DestroyChar() - character : " .. character .. " Destroyed, rip :(")
    DelayedCall(250, function()
        Osi.SetOnStage(character, 0)
        Osi.RequestDeleteTemporary(character)
    end)
end