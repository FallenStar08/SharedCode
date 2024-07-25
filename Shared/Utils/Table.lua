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

--- Merges two sets
---@param set1 table The first set
---@param set2 table The second set
---@return table The merged set
function Table.MergeSets(set1, set2)
    local mergedSet = {}

    for key, value in pairs(set1) do
        if mergedSet[key] then
            --Key already exists, dontcare+you'recringe
        else
            mergedSet[key] = value
        end
    end

    for key, value in pairs(set2) do
        if mergedSet[key] then
            --Key already exists, dontcare+you'recringe
        else
            mergedSet[key] = value
        end
    end
    return mergedSet
end

--- Checks if a value is present in the target array
---@param target table The table containing strings to search.
---@param value string|number The string/number to check for presence in the target table.
---@return boolean result true if the value is found in the target table, false otherwise.
function Table.ContainsAny(target, value)
    if not (target and value) then return false end
    for _, templateUuid in ipairs(target) do
        if templateUuid == value then
            return true
        end
    end
    return false
end

---returns a new table that is a copy of the original
---@param orig table
---@return table
function Table.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Table.DeepCopy(orig_key)] = Table.DeepCopy(orig_value)
        end
        setmetatable(copy, Table.DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end

    return copy
end

---map function since lua doesn't have it (cringe)
---@param table table is a table, yes.
---@param fun function function to apply to each element
---@return table table the modified table
function Table.Map(table, fun)
    local t = {}
    for k, v in pairs(table) do
        t[k] = fun(v)
    end
    return t
end
