---@diagnostic disable: duplicate-set-field

-- -------------------------------------------------------------------------- --
--                                    LOCA                                    --
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
    if success and translatedName then
        return translatedName
    else
        --Not really an error...
        return "FALLEN_TRANSLATED_NAME_ERROR"
    end
end


---Updates the content of a translated string identified by the given handle.
---@param handle string The handle of the translated string to be updated.
---@param content string The new content for the translated string.
function UpdateTranslatedString(handle, content)
    Ext.Loca.UpdateTranslatedString(handle, content)
end

---Retrieves the content of a translated string identified by the given handle.
---@param handle? string The handle of the translated string to be retrieved.
---@return string|nil content The content of the translated string.
function GetTranslatedString(handle)
    if handle then
        return Ext.Loca.GetTranslatedString(handle)
    end
end

-- Function to access nested fields in a table with pcall
function SafeGetField(table, path)
    local value = table
    local fields = {}

    -- Extract fields from path using gmatch
    for match in path:gmatch("[^%.]+") do
        fields[#fields + 1] = match
    end

    -- Traverse fields
    for _, field in ipairs(fields) do
        local success, result = pcall(function() return value[field] end)
        if success and result ~= nil then
            value = result
        else
            return nil
        end
    end

    return value
end

function GrabHandle(data, fieldName)
    local success, result = pcall(function() return GetTranslatedString(data[fieldName].Handle.Handle) end)
    return success and result or nil
end
