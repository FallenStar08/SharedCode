---Guess this is my life now
---@param eventId string
---@param content string
---@param force? number
---@param initiation? GUIDSTRING --Char who initatittititited the box idk fuck this shit garbage ass function fuck
---@param char1? GUIDSTRING
---@param char2? GUIDSTRING
---@param char3? GUIDSTRING
function FallenMessageBox(eventId, content, initiation, char1, char2, char3, force)
    force = force or 1
    initiation = initiation or Osi.GetHostCharacter()
    char1 = char1 or ""
    char2 = char2 or ""
    char3 = char3 or ""
    _G.INITIATIOR = initiation
    Osi.ReadyCheckSpecific(eventId, content, force, initiation, char1, char2, char3)
end