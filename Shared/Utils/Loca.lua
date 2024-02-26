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

    -- Handle errors by trying to get the name from Ext.Template.GetTemplate(UUID).DisplayName.Handle.Handle
    -- Hack for tmog cause I'm bad at programming
    if not success or not translatedName then
        success, translatedName = pcall(function()
            local template = Template.GetTemplate(UUID)
            ---@diagnostic disable-next-line: undefined-field
            if template and template.DisplayName and template.DisplayName.Handle and template.DisplayName.Handle.Handle then
                ---@diagnostic disable-next-line: undefined-field
                return GetTranslatedString(template.DisplayName.Handle.Handle)
            end
        end)
    end

    return success and translatedName or "FALLEN_TRANSLATED_NAME_ERROR"
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

---Color a given string
---@param string string string to colorize
---@param color string hexadecimal color for html tag
---@return string string colorized string
function ColorTranslatedString(string, color)
    return string.format("<font color='%s'>%s</font>", color, string)
end
