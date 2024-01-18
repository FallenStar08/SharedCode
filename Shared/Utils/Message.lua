---@diagnostic disable: duplicate-set-field, duplicate-doc-alias

-- -------------------------------------------------------------------------- --
--                             Messages functions                             --
-- -------------------------------------------------------------------------- --

---@alias MESSAGETYPE string | "INFO"|"WARNING"|"ERROR"|"DEBUG"

local PrintTypes = {
    INFO = 1,
    ERROR = 2,
    WARNING = 3,
    DEBUG = 4
}


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
---@param messageType? MESSAGETYPE The type of the message (e.g., "INFO", "ERROR", "WARNING").
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
    customPrefix = customPrefix or MOD_INFO.MOD_NAME
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