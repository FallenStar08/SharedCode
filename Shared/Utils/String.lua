---@diagnostic disable: duplicate-set-field

-- -------------------------------------------------------------------------- --
--                                   STRING                                   --
-- -------------------------------------------------------------------------- --

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
---@return GUIDSTRING UUIDsuffix with prefix removed.
function GUID(str)
    if str then
        return string.sub(str, -36)
    else
        return NULLUUID
    end
end

---Check if string contains a substring
---@param str string the string to check
---@param substr string the substring
---@param caseSensitive? boolean 
---@return boolean
function StringContains(str, substr,caseSensitive)
    caseSensitive=caseSensitive or false
    if caseSensitive then
        return string.find(str, substr, 1, true) ~= nil
    else
        str=string.lower(str)
        substr=string.lower(substr)
        return string.find(str, substr, 1, true) ~= nil
    end
end

function RemoveTextBefore(input, text)
    if input then
        local index = string.find(input, text)
        if index then
            return string.sub(input, index)
        else
            return nil
        end
    end
end
