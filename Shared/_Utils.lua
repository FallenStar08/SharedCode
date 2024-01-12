---@diagnostic disable: duplicate-set-field
JSON = {}
Files = {}
Table = {}
Template = {}
Messages = {}
Treasure = {}

PrintTypes = {
    INFO = 1,
    ERROR = 2,
    WARNING = 3,
    DEBUG = 4
}


-- -------------------------------------------------------------------------- --
--                             Messages functions                             --
-- -------------------------------------------------------------------------- --
local printError = Ext.Utils.PrintError
local printWarning = Ext.Utils.PrintWarning
function ConcatPrefix(prefix, message)
    local paddedPrefix = prefix .. string.rep(" ", MAX_PREFIX_LENGTH - #prefix) .. " : "

    if type(message) == "table" then
        local serializedMessage = JSON.Stringify(message)
        return paddedPrefix .. serializedMessage
    else
        return paddedPrefix .. tostring(message)
    end
end

--Blatantly stolen from KvCampEvents, mine now
local function ConcatOutput(...)
    local varArgs = { ... }
    local outStr = ""
    local firstDone = false
    for _, v in pairs(varArgs) do
        if not firstDone then
            firstDone = true
            outStr = tostring(v)
        else
            outStr = outStr .. " " .. tostring(v)
        end
    end
    return outStr
end

--- Prints a formatted message to the console and logs it if logging is enabled.
---@param content any The content of the message to be printed and logged.
---@param messageType? string The type of the message (e.g., "INFO", "ERROR", "WARNING").
--- Defaults to "INFO" if not provided.
---@param textColor? number The ANSI color code for the text. Defaults to blue if not provided.
---@param customPrefix? string A custom prefix for the message. Defaults to MOD_NAME if not provided.
---@param rainbowText? boolean If true, the text will be displayed in rainbow colors. Defaults to false.
---@param prefixLength? number The length of the prefix. Defaults to 15 if not provided.
function BasicPrint(content, messageType, textColor, customPrefix, rainbowText, prefixLength)
    local logLevel = (CONFIG and CONFIG.DEBUG_MESSAGES) or 3
    prefixLength = prefixLength or 15
    messageType = messageType or "INFO"
    local textColorCode = textColor or TEXT_COLORS.blue -- Default to blue
    customPrefix = customPrefix or MOD_NAME
    if CONFIG and CONFIG.LOG_ENABLED == 1 then
        Files.LogMessage(ConcatOutput(ConcatPrefix(customPrefix .. "  [" .. messageType .. "]", content)))
    end

    if logLevel <= 0 then
        return
    end

    if PrintTypes[messageType] and logLevel >= PrintTypes[messageType] then
        local padding = string.rep(" ", prefixLength - #customPrefix)
        local message = ConcatOutput(ConcatPrefix(customPrefix .. padding .. "  [" .. messageType .. "]", content))
        local coloredMessage = rainbowText and GetRainbowText(message) or
            string.format("\x1b[%dm%s\x1b[0m", textColorCode, message)
        if messageType == "ERROR" then
            printError(coloredMessage)
        elseif messageType == "WARNING" then
            printWarning(coloredMessage)
        else
            print(coloredMessage)
        end
    end
end

---Prints an error message to the console and logs it if logging is enabled.
---@param content any The content of the error message to be printed and logged.
---@param textColor? number The ANSI color code for the text. Defaults to red if not provided.
function BasicError(content, textColor)
    BasicPrint(content, "ERROR", TEXT_COLORS.red)
end

---Prints a warning message to the console and logs it if logging is enabled.
---@param content any The content of the error message to be printed and logged.
---@param textColor? number The ANSI color code for the text. Defaults to yellow if not provided.
function BasicWarning(content, textColor)
    BasicPrint(content, "WARNING", TEXT_COLORS.yellow)
end

---Prints a debug message to the console and logs it if logging is enabled.
---@param content any The content of the error message to be printed and logged.
---@param textColor? number The ANSI color code for the text. Defaults to blue if not provided.
function BasicDebug(content, textColor)
    BasicPrint(content, "DEBUG", textColor)
end

---Applies a rainbow color effect to a given string.
---The ANSI color codes are used to achieve the rainbow effect.
---@param text string The input text to be colored with a rainbow effect.
---@return string coloredText input text with rainbow colors applied.
function GetRainbowText(text)
    local colors = { "31", "33", "32", "36", "35", "34" } -- Red, Yellow, Green, Cyan, Magenta, Blue
    local coloredText = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        local color = colors[i % #colors + 1]
        coloredText = coloredText .. string.format("\x1b[%sm%s\x1b[0m", color, char)
    end
    return coloredText
end

-- ------------------------------------------------------------------------------------------------------
-- File I/O Stuff credit to the kv camp event author, I basically just made their code/functions worse --
-- ------------------------------------------------------------------------------------------------------

--- Saves the given content to the specified file path.
--- @param path string The path to save the file to, relative to the mod folder.
--- @param content string The content to save to the file.
--- @return boolean result True if the save was successful, false otherwise.
function Files.Save(path, content)
    path = Files.Path(path)
    return Ext.IO.SaveFile(path, content)
end

--- Loads the content of the file at the given path.
--- @param path string The path of the file to load, relative to the mod folder.
function Files.Load(path)
    path = Files.Path(path)
    return Ext.IO.LoadFile(path)
end

--- Concatenates the folder name and file path to get the full path.
---@param filePath string The file path relative to the folder.
---@return string fullPath The full path including the folder name.
function Files.Path(filePath)
    return FOLDER_NAME .. "/" .. filePath
end

--- Parses a JSON string into a Lua table.
---@param json_str string The JSON string to parse.
---@return table
function JSON.Parse(json_str)
    return Ext.Json.Parse(json_str)
end


--- Stringifies the given Lua data structure into a JSON string.
---@param data any The data to stringify
---@return string The JSON string representation of the input data
function JSON.Stringify(data)
    return Ext.Json.Stringify(data)
end

---Moves a file from the old path to the new path.
---The content of the file is loaded, saved to the new path, and then the original file is cleared .
---Mainly used to clear the log file.
---@param oldPath string The path of the file to be moved.
---@param newPath string The destination path for the moved file.
---@return boolean result true if the move operation is successful, otherwise false.
function Files.Move(oldPath, newPath)
    local content = Files.Load(oldPath)
    if content then
        Files.Save(newPath, content)
        Files.Save(oldPath, "")
        return true
    else
        BasicError("Files.Move() - Failed to read file from oldPath: '" .. (oldPath or "") .. "'")
        return false
    end
end

---Converts a Lua table to a JSON formated string and saves it to the specified file path.
---@param lua_table table The Lua table to be converted to JSON.
---@param filePath string The path of the file where the JSON string will be saved.
function JSON.LuaTableToFile(lua_table, filePath)
    local json_str = JSON.Stringify(lua_table)
    Files.Save(filePath, json_str)
end

---Loads a JSON string from a file and parses it into a Lua table.
---@param filePath string The path of the file containing the JSON string.
---@return table|nil table_or_nil Lua table parsed from the JSON string, or nil if parsing fails.
function JSON.LuaTableFromFile(filePath)
    local json_str = Files.Load(filePath)
    if json_str and json_str ~= "" then
        return JSON.Parse(json_str)
    else
        return nil
    end
end

-- -------------------------------------------------------------------------- --
--                                    LOGS                                    --
-- -------------------------------------------------------------------------- --


local logBuffer = ""         -- Initialize an empty log buffer
local logBufferMaxSize = 512 -- Maximum buffer size before flushing
local function GetTimestamp()
    local time = Ext.Utils.MonotonicTime()
    local milliseconds = time % 1000
    local seconds = Custom_floor(time / 1000) % 60
    local minutes = Custom_floor((time / 1000) / 60) % 60
    local hours = Custom_floor(((time / 1000) / 60) / 60) % 24
    return string.format("[%02d:%02d:%02d.%03d]",
        hours, minutes, seconds, milliseconds)
end

--- Appends a timestamped message to the log buffer.
--- The log buffer is flushed if its size exceeds the maximum specified above (default is 512).
---@param message string The message to be logged.
function Files.LogMessage(message)
    local logMessage = GetTimestamp() .. " " .. message
    logBuffer = logBuffer .. logMessage .. "\n"

    -- Check if the buffer size exceeds the maximum, then flush it
    if #logBuffer >= logBufferMaxSize then
        Files.FlushLogBuffer()
    end
end

--- Flushes the log buffer by appending its content to the log file.
--- The log buffer is cleared after flushing.
function Files.FlushLogBuffer()
    if logBuffer ~= "" then
        local logPath = Paths.logPath
        local fileContent = Files.Load(logPath) or ""
        Files.Save(logPath, fileContent .. logBuffer)
        logBuffer = "" -- Clear the buffer
    end
end

--- Clears the content of the log file specified in the configuration.
function Files.ClearLogFile()
    local logPath = Paths.logPath
    if Files.Load(logPath) then
        Files.Save(logPath, "")
    end
end

-- -------------------------------------------------------------------------- --
--                             List & Table stuff                             --
-- -------------------------------------------------------------------------- --

--- Checks if all values in the valueList table are present in the given table.
---@param tbl table The table to check
---@param valueList table The list of values to find inside the table
---@return boolean True if all values in the valueList are present, false otherwise
function Table.CheckIfAllValuesExist(tbl, valueList)
    for _, element in pairs(valueList) do
        local found = false
        for _, t in pairs(tbl) do
            if t == element then
                found = true
                break
            end
        end
        if not found then
            return false
        end
    end
    return true
end



---Checks if a specific value exists in the given table.
---@param tbl table The table to search for the value.
---@param value any The value to check for existence in the table.
---@return boolean result true if the value exists in the table, otherwise false.
function Table.CheckIfValueExists(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

---Compares two sets represented as tables and returns the elements that exist in the first set but not in the second set.
---@param set1 table The first set table for comparison.
---@param set2 table The second set table for comparison.
---@return table diffTable table containing elements from set1 that are not present in set2. If no differences are found, an empty table is returned.
function Table.CompareSets(set1, set2)
    local result = {}

    for name, uid in pairs(set1) do
        if not set2[name] then
            result[name] = uid
        end
    end

    if next(result) == nil then
        return {}
    else
        return result
    end
end

--Check filter lists
function Table.IsValidSet(set)
    local isValid = true
    if not set then
        isValid = false
    else
        for k, v in pairs(set) do
            if type(k) ~= "string" or type(v) ~= "string" then
                BasicWarning("IsValidSet() - Set isn't valid : ")
                BasicWarning(set)
                isValid = false
                break
            end
        end
    end
    return isValid
end

function Table.ProcessTables(baseTable, keeplistTable, selllistTable)
    -- User Lists only, clear baseTable
    if CONFIG["CUSTOM_LISTS_ONLY"] >= 1 then baseTable = {} end

    --Merge sell entries to the base list
    for name, uid in pairs(selllistTable) do baseTable[name] = uid end
    --Merge keep entries to the base list
    for name, uid in pairs(keeplistTable) do baseTable[name] = nil end
    return baseTable
end

function Table.FindKeyInSet(set, key)
    return set[key] ~= nil
end

--- Merges two sets, throwing an error if a key already exists.
---@param set1 table The first set
---@param set2 table The second set
---@return table The merged set
function Table.MergeSets(set1, set2)
    local mergedSet = {}

    -- Merge set1 into mergedSet
    for key, value in pairs(set1) do
        if mergedSet[key] then
            BasicError("Key '" .. key .. "' already exists in the merged set.")
        else
            mergedSet[key] = value
        end
    end

    -- Merge set2 into mergedSet
    for key, value in pairs(set2) do
        if mergedSet[key] then
            BasicError("Key '" .. key .. "' already exists in the merged set.")
        else
            mergedSet[key] = value
        end
    end
    return mergedSet
end

-- -------------------------------------------------------------------------- --
--                                    Math                                    --
-- -------------------------------------------------------------------------- --
--Todo remove this shit it's stupid math.floor is a thing
function Custom_floor(x)
    return x - x % 1
end

-- -------------------------------------------------------------------------- --
--                                    Misc                                    --
-- -------------------------------------------------------------------------- --
---Measure the execution time of a given function
---@param func function the function to measure the execution time of
function MeasureExecutionTime(func)
    local startTime = Ext.Utils.MonotonicTime()
    func() -- Execute the provided function
    local endTime = Ext.Utils.MonotonicTime()
    local elapsedTime = endTime - startTime
    return elapsedTime
end

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

---Delay a function call by the given time
---@param ms integer
---@param func function
function DelayedCall(ms, func)
    local Time = 0
    local handler
    handler = Ext.Events.Tick:Subscribe(function(e)
        Time = Time + e.Time.DeltaTime * 1000 -- Convert seconds to milliseconds

        if (Time >= ms) then
            func()
            Ext.Events.Tick:Unsubscribe(handler)
        end
    end)
end

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

-- -------------------------------------------------------------------------- --
--                             tables of character                            --
-- -------------------------------------------------------------------------- --

---@return table squadies list of the current party members
function GetSquadies()
    local squadies = {}
    local players = Osi.DB_Players:Get(nil)
    for _, player in pairs(players) do
        local pattern = "%f[%A]dummy%f[%A]"
        if not string.find(player[1]:lower(), pattern) then
            table.insert(squadies, string.sub(player[1], -36))
        else
            BasicDebug("Ignoring dummy")
        end
    end
    SQUADIES = squadies
    return squadies
end

---@return table summonies a list of all the summons owned by players
function GetSummonies()
    local summonies = {}
    local summons = Osi.DB_PlayerSummons:Get(nil)
    for _, summon in pairs(summons) do
        if #summon[1] > 36 then
            table.insert(summonies, string.sub(summon[1], -36))
        end
    end
    SUMMONIES = summonies
    return summonies
end

---get all characters currently involded in a combat
---@return table battlies all the character involved in a combat
function GetBattlies()
    local battlies = {}
    local baddies = Osi.DB_Is_InCombat:Get(nil, nil)
    for _, bad in pairs(baddies) do
        table.insert(battlies, string.sub(bad[1], -36))
        --print(bad[1])
        return battlies
    end
end

--TODO FINSIH writing this shit, (check partymember/enemies)

---Returns a list of party members involded in a given combat guid
---@param guid string the combat guid to check
---@return table? partyMembers the party members involved in the given combat guid or nil
function GetPartyMembersInCombatGuid(guid)
    local combat = Osi.DB_Is_InCombat:Get(nil, guid)
    local partyMembers = {}
    for _, partyMember in pairs(combat) do
        table.insert(partyMembers, GUID(partyMember[1]))
    end
    if not next(partyMembers) then return nil end
    return partyMembers
end

---Returns a list of enemies involved in a given combat guid
---@param guid string the combat guid to check
---@return table? enemies the enemies involved in the given combat guid or nil
function GetEnemiesInCombatGuid(guid)
    local combat = Osi.DB_Is_InCombat:Get(nil, guid)
    local enemies = {}
    for _, enemy in pairs(combat) do
        table.insert(enemies, GUID(enemy[1]))
    end
    if not next(enemies) then return nil end
    return enemies
end

-- -------------------------------------------------------------------------- --
--                              String and Names                              --
-- -------------------------------------------------------------------------- --
---Retrieves the translated name associated with the specified UUID.
---The function attempts to resolve the translated string for the display name of the entity with the given UUID.
---In case of an error during the resolution process, a default error message is logged, and "No name" is returned.
---@param UUID string The UUID of the entity for which the translated name is to be retrieved.
---@return string Name translated name of the entity or "No name" if an error occurs.
function GetTranslatedName(UUID)
    local success, translatedName = pcall(function()
        return GetTranslatedString(Osi.GetDisplayName(UUID))
    end)

    -- Handle errors by logging a basic debug message and returning a default "No name" string.
    if success then
        return translatedName
    else
        --Not really an error...
        BasicDebug("Error in GetTranslatedName: " .. translatedName)
        return "No name"
    end
end

---Updates the content of a translated string identified by the given handle.
---@param handle string The handle of the translated string to be updated.
---@param content string The new content for the translated string.
function UpdateTranslatedString(handle, content)
    Ext.Loca.UpdateTranslatedString(handle, content)
end

---Retrieves the content of a translated string identified by the given handle.
---@param handle string The handle of the translated string to be retrieved.
---@return string content The content of the translated string.
function GetTranslatedString(handle)
    return Ext.Loca.GetTranslatedString(handle)
end

---Removes trailing numeric characters from the input string.
---This function is designed for handling UUIDs with trailing underscore and numbers.
---@param inputString string The input string with potential trailing numeric characters.
---@return string outputString string with trailing numeric characters removed.
---@return integer numberOfMatch the total number of matches that occured
function RemoveTrailingNumbers(inputString)
    return inputString:gsub("_%d%d%d$", "")
end

---Checks if a string is empty or contains only whitespace characters.
---@param str string The string to be checked.
---@return boolean result Returns true if the string is empty or contains only whitespace characters; otherwise, returns false.
function StringEmpty(str)
    return not string.match(str, "%S")
end

---Checks if a string starts with a specified prefix.
---@param str string The input string to be checked.
---@param prefix string The prefix to check for at the beginning of the string.
---@return boolean result if the string starts with the specified prefix, otherwise false.
function StartsWith(str, prefix)
    return string.sub(str, 1, string.len(prefix)) == prefix
end

---Checks if a string ends with a specified suffix.
---@param str string input string to be checked.
---@param suffix string suffix to check for at the end of the string.
---@return boolean result if the string ends with the specified suffix, otherwise false.
function EndsWith(str, suffix)
    return string.sub(str, -string.len(suffix)) == suffix
end

---Extracts the GUID suffix from a string.
---@param str string input string from which to extract the GUID.
---@return string UUIDsuffix with prefix removed.
function GUID(str)
    return string.sub(str, -36)
end

-- -------------------------------------------------------------------------- --
--                               Entities stuff                               --
-- -------------------------------------------------------------------------- --
function EntityToUuid(entity)
    return Ext.Entity.HandleToUuid(entity)
end
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

-- -------------------------------------------------------------------------- --
--                                  Templates                                 --
-- -------------------------------------------------------------------------- --
if SE_VERSION >= 10 then
    Template.GetAllCacheTemplates = Ext.Template.GetAllCacheTemplates
    Template.GetAllLocalCacheTemplates = Ext.Template.GetAllLocalCacheTemplates
    Template.GetAllLocalTemplates = Ext.Template.GetAllLocalTemplates
    Template.GetAllRootTemplates = Ext.Template.GetAllRootTemplates
    Template.GetCacheTemplate = Ext.Template.GetCacheTemplate
    Template.GetLocalCacheTemplate = Ext.Template.GetLocalCacheTemplate
    Template.GetLocalTemplate = Ext.Template.GetLocalTemplate

    Template.GetRootTemplate = Ext.Template.GetRootTemplate
    --Combination of all the GetXTemplate function
    Template.GetTemplate = Ext.Template.GetTemplate
end

-- -------------------------------------------------------------------------- --
--                                  Treasures                                 --
-- -------------------------------------------------------------------------- --

---Retrieves the treasure table associated with the specified name.
---@param treasureTableName (string) The name of the treasure table to retrieve.
---@return table? TreasureTable treasure table associated with the specified name, or nil if not found.
function Treasure.GetTT(treasureTableName)
    return Ext.Stats.TreasureTable.GetLegacy(treasureTableName)
end

--- Retrieves the items contained in the specified treasure category.
---@param treasureCategoryName string The name of the treasure category to retrieve.
---@return table? TreasureCategory items contained in the specified treasure category, or nil if not found.
function Treasure.GetTC(treasureCategoryName)
    return Ext.Stats.TreasureCategory.GetLegacy(treasureCategoryName)
end

--- Generate items from a treasure table
--- Written by focus, yoinked
---@param treasureTable string Name of the TT
---@param target? string Who to give the content to
---@param level? integer level to use for the TT loot generation
---@param finder? string idk
---@param generateInBag? boolean if true will put the content into a bag
function Treasure.GenerateTreasureTable(treasureTable, target, level, finder, generateInBag)
    local bag = generateInBag ~= false and Osi.CreateAt(POUCH, 0, 0, 0, 0, 0, "")
    target = target or Osi.GetHostCharacter()

    if level == nil then
        if Osi.IsItem(target) == 1 then
            level = -1
        else
            level = Osi.GetLevel(target)
        end
    end

    if finder == nil then
        if Osi.IsItem(target) == 1 then
            finder = Osi.GetHostCharacter()
        else
            finder = target
        end
    end

    if bag then
        Osi.GenerateTreasure(bag, treasureTable, level, finder)
        Osi.ToInventory(bag, target)
    else
        Osi.GenerateTreasure(target, treasureTable, level, finder)
    end
end

-- -------------------------------------------------------------------------- --
--                                    ITEMS                                   --
-- -------------------------------------------------------------------------- --

--- Recursively iterates through an entity's inventory and all sub-inventories, building a table containing all items.
---@param entity any The entity whose inventory to iterate
---@param processedInventory? table Table to accumulate results
---@param tagFilter? table The table of tags to filter items (optional)
---@return table processedInventory Table containing all items in entity's inventory tree table format: 
---["uuid"]={amount(int), statsId(str), tags(table), template(str)}
function DeepIterateInventory(entity, tagFilter, processedInventory)
    tagFilter = tagFilter or nil
    processedInventory = processedInventory or {}
    local entityInventory = entity.InventoryOwner.PrimaryInventory
    local entityItemsList = entityInventory.InventoryContainer.Items

    for _, entry in pairs(entityItemsList) do
        local item = entry.Item
        local isContainer = item.InventoryOwner ~= nil
        local StackMember = item.InventoryStackMember
        local data = {
            template = Osi.GetTemplate(item.Uuid and item.Uuid.EntityUuid) or "TemplateError",
            tags = item.Tag.Tags or {},
            statsId = item.Data.StatsId or "StatsIdError",
            amount = Osi.GetStackAmount(item.Uuid.EntityUuid) or 0
        }
        local uuid = item.Uuid and item.Uuid.EntityUuid or nil

        -- Check if the item has all the specified tags
        if tagFilter and not Table.CheckIfAllValuesExist(data.tags, tagFilter) then
            -- Skip this item if it doesn't match all tags in the filter
            goto continue
        end

        if StackMember then
            local itemStack = StackMember.Stack.InventoryStack.Arr_u64
            for _, stackElement in pairs(itemStack) do
                local stackData = {
                    template = stackElement.ServerItem.Item.Template.Id or "TemplateError",
                    tags = stackElement.Tag.Tags or {},
                    statsId = stackElement.Data.StatsId or "StatsIdError",
                    amount = Osi.GetStackAmount(stackElement.Uuid.EntityUuid) or "AmountError"
                }
                local stackUuid = stackElement.Uuid and stackElement.Uuid.EntityUuid

                -- Check if the item has all the specified tags
                if tagFilter and not Table.CheckIfAllValuesExist(stackData.tags, tagFilter) then
                    -- Skip this stack item if it doesn't match all tags in the filter
                    goto continue_stack
                end

                processedInventory[stackUuid] = stackData

                ::continue_stack::
            end
        elseif not StackMember and uuid then
            processedInventory[uuid] = data
        end

        ::continue::

        if isContainer then
            DeepIterateInventory(item, tagFilter, processedInventory)
        end
    end

    return processedInventory
end


function HasItemTemplate(character,root )
    if Osi.TemplateIsInInventory(root, character) >= 1 then
        return true
    else
        return false
    end
end

-- -------------------------------------------------------------------------- --
--                                   ModVars                                  --
-- -------------------------------------------------------------------------- --
--TODO nothing
---Register Mod variable, kinda like pVars but based
---@param variableName string name of the variable to register
---@param config? table see BG3SE api doc fuck this shit
---@param modUuid? string don't care
function RegisterModVariable(variableName, config, modUuid)
    modUuid = modUuid or MOD_UUID
    config = config or {}
    Ext.Vars.RegisterModVariable(modUuid, variableName, config)
end

function GetModVariables()
    return Ext.Vars.GetModVariables(MOD_UUID)
end

---Sync things, for nerds.
function SyncModVariables()
    Ext.Vars.DirtyModVariables(MOD_UUID)
    Ext.Vars.SyncModVariables(MOD_UUID)
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

-- -------------------------------------------------------------------------- --
--                                   EVENTS                                   --
-- -------------------------------------------------------------------------- --
