---@diagnostic disable: duplicate-set-field

-- -------------------------------------------------------------------------- --
--                                   ModVars                                  --
-- -------------------------------------------------------------------------- --
--TODO nothing
---Register Mod variable, kinda like pVars but based
---@param variableName string name of the variable to register
---@param config? table see BG3SE api doc fuck this shit
---@param modUuid? string don't care
function RegisterModVariable(variableName, config, modUuid)
    modUuid = modUuid or MOD_INFO.MOD_UUID
    config = config or {}
    Ext.Vars.RegisterModVariable(modUuid, variableName, config)
end

function GetModVariables()
    return Ext.Vars.GetModVariables(MOD_INFO.MOD_UUID)
end

---Sync things, for nerds.
function SyncModVariables()
    Ext.Vars.DirtyModVariables(MOD_INFO.MOD_UUID)
    Ext.Vars.SyncModVariables(MOD_INFO.MOD_UUID)
end

-- -------------------------------------------------------------------------- --
--                                 Custom Vars                                --
-- -------------------------------------------------------------------------- --
--TODO nothing
---Register User variable, your home made component basically.
---@param variableName string name of the variable to register
---@param config? table see BG3SE api doc fuck this shit
function RegisterUserVariable(variableName, config)
    config = config or {}
    Ext.Vars.RegisterUserVariable(variableName,config)
end

---Sync things, for nerds.
function SyncUserVariables()
    Ext.Vars.DirtyUserVariables()
    Ext.Vars.SyncUserVariables()
end