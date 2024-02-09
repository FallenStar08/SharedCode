---@diagnostic disable: duplicate-set-field

Table = {}

-- -------------------------------------------------------------------------- --
--                             List & Table stuff                             --
-- -------------------------------------------------------------------------- --

--- Checks if all values in the valueList table are present in the given table.
---@param tbl table The table to check
---@param valueList table The list of values to find inside the table
---@return boolean True if all values in the valueList are present, false otherwise
function Table.CheckIfAllValuesExist(tbl, valueList)
    if not (tbl and valueList) then
        return false
    end
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

--Todo move to autosell
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
            --BasicError("Key '" .. key .. "' already exists in the merged set.")
        else
            mergedSet[key] = value
        end
    end

    -- Merge set2 into mergedSet
    for key, value in pairs(set2) do
        if mergedSet[key] then
            --BasicError("Key '" .. key .. "' already exists in the merged set.")
        else
            mergedSet[key] = value
        end
    end
    return mergedSet
end

--- Checks if a  string is present in the array of  UUIDs.
---@param target table The table containing strings to search.
---@param value string The string to check for presence in the target table.
---@return boolean result true if the value is found in the target table, false otherwise.
function Table.ContainsAny(target, value)
    if not(target and value) then return false end
    for _, templateUuid in ipairs(target) do
        if templateUuid == value then
            return true
        end
    end
    return false
end

function Table.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Table.DeepCopy(orig_key)] = Table.DeepCopy(orig_value)
        end
        setmetatable(copy, Table.DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end