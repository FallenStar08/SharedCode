-- -------------------------------------------------------------------------- --
--                             Config IO functions                            --
-- -------------------------------------------------------------------------- --

local default_config_tbl = Ext.Require("Server/_DefaultTables.lua") or {}

--MetaTable for config, I forgot what I wanted to do with it
local configMetatable = {
    __index = function(self, key)
        local method = rawget(self, key)
        if method then
            return method
        else
            local metatable = getmetatable(self)
            while metatable do
                method = rawget(metatable, key)
                if method then
                    return method
                end
                metatable = getmetatable(metatable)
            end
            BasicDebug("The following key was not found : " .. key)
            BasicDebug(self)
            return nil
        end
    end,

    __newindex = function(self, key, value)
        print("here")
        if key ~= "__configChanged" then
            rawset(self, key, value)
            rawset(self, "__configChanged", true)
            self:save()
        end
    end,


    __call = function(self, filePath)
        --Load config from file
        local success, error_message = pcall(function()
            local fileConfig = JSON.LuaTableFromFile(filePath) or {}
            rawset(self, "__configChanged", false)
            --rawset(self, "__configChanged", false)
            if next(fileConfig) == nil then
                BasicPrint("Creating default config file at : " .. filePath)
                -- Initialize with default values if the fileConfig is empty
                for key, value in pairs(default_config_tbl) do
                    fileConfig[key] = value
                end
                rawset(self, "__configChanged", true)
            end
            ---@diagnostic disable-next-line: undefined-global
            setmetatable(fileConfig, configMetatable)

            for k, v in pairs(fileConfig) do
                rawset(self, k, v)
            end
        end)

        if not success then
            BasicWarning("Config() - " .. error_message)
        end
        self:save()
        return self
    end,

    __tostring = function(self)
        -- Convert config to string
        return JSON.Stringify(self)
    end
}

--set up a config table with the metatable
function CreateConfig(filePath)
    local config = {}
    setmetatable(config, configMetatable)
    return config(filePath)
end

-- Save table to file
function configMetatable:save()
        BasicPrint("save() - Config file saved")
        BasicDebug(self)
        local dataToSave = {}
        for k, v in pairs(self) do
            if k ~= "__configChanged" then
                dataToSave[k] = v
            end
        end
        JSON.LuaTableToFile(dataToSave, Paths.config_json_file_path)
        rawset(self, "__configChanged", false)
end

-- Load from file (shouldn't be needed)
function configMetatable:load()
    local success, error_message = pcall(function()
        local fileConfig = JSON.LuaTableFromFile(Paths.config_json_file_path) or default_config_tbl
        setmetatable(fileConfig, configMetatable)
        for k, v in pairs(fileConfig) do
            self[k] = v
        end
    end)

    if not success then
        BasicWarning("load() - " .. error_message)
    end
end

--Validate config structure
function configMetatable:checkStructure()
    local defaultConfig = default_config_tbl
    for key, value in pairs(defaultConfig) do
        if self[key] == nil then
            self[key] = value
            BasicWarning("checkStructure() - Added missing key : " .. key .. " to the configuration file")
            self.__configChanged = true
        elseif type(self[key]) ~= type(value) then
            BasicWarning(string.format(
                "checkStructure() - Config key '%s' has incorrect type. Reverting to default.", key))
            self[key] = value
            self.__configChanged = true
        end
    end
    self:save() -- Save after checking structure
end

-- Upgrade config version
function configMetatable:upgrade()
    self["VERSION"] = MOD_VERSION
    self.__configChanged = true
    self:save()
end

function InitConfig()
    Files.ClearLogFile()
    BasicPrint(
        string.format("Config.Init() - %s mod by FallenStar VERSION : %s starting up... ", MOD_NAME,
            CurrentVersion),
        "INFO", nil, nil, true)

    -- Load the config from the file or create a new one if it doesn't exist
    CONFIG = CreateConfig(Paths.config_json_file_path)

    -- Check the Config Structure and correct it if needed
    CONFIG:checkStructure()

    if CONFIG.VERSION ~= CurrentVersion then
        BasicWarning("Config.Init() - Detected version mismatch, upgrading file...")
        CONFIG:upgrade()
    else
        BasicPrint("Config.Init() - VERSION check passed")
    end

    BasicDebug("Config.Init() - DEBUG MESSAGES ARE ENABLED")
    BasicDebug(CONFIG)
end
