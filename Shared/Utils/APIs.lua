--File contains wrapper functions for other mods apis (only mcm atm, probably forever)

---Get value for setting from MCM
---@param settingName string settingName to get the value of
---@return any value the setting's value
function GetMCMSettingValue(settingName)
    return Mods.BG3MCM.MCMAPI:GetSettingValue(settingName, MOD_INFO.MOD_UUID)
end

GetMCM = GetMCMSettingValue

---Return a table with all settings id : value pairs
---@return table<string, any>
function GetMCMSettingTable()
    return Mods.BG3MCM.MCMAPI:GetAllModSettings(MOD_INFO.MOD_UUID)
end

GetMCMTable = GetMCMSettingTable
