function Levenshtein(str1, str2)
    local len1, len2 = #str1 + 1, #str2 + 1
    local matrix = {}
    for i = 1, len1 do
        matrix[i] = {}
        for j = 1, len2 do
            if i == 1 then
                matrix[i][j] = j - 1
            elseif j == 1 then
                matrix[i][j] = i - 1
            else
                local cost = (str1:sub(i - 1, i - 1) ~= str2:sub(j - 1, j - 1) and 1 or 0)
                matrix[i][j] = math.min(
                    matrix[i - 1][j] + 1,
                    matrix[i][j - 1] + 1,
                    matrix[i - 1][j - 1] + cost
                )
            end
        end
    end
    return matrix[len1][len2]
end

function JaroWinkler(str1, str2)
    local len1, len2 = #str1, #str2
    local maxLen = math.max(len1, len2)

    if maxLen == 0 then
        return 0
    end

    local matchWindow = math.floor(maxLen / 2) - 1

    local matches = 0
    local transpositions = 0

    local str1Flags = {}
    local str2Flags = {}

    for i = 1, len1 do
        local startMatch = math.max(1, i - matchWindow)
        local endMatch = math.min(i + matchWindow, len2)

        for j = startMatch, endMatch do
            if not str2Flags[j] and str1:sub(i, i) == str2:sub(j, j) then
                str1Flags[i] = true
                str2Flags[j] = true
                matches = matches + 1
                break
            end
        end
    end

    if matches == 0 then
        return 0
    end

    local k = 1
    for i = 1, len1 do
        if str1Flags[i] then
            while not str2Flags[k] do
                k = k + 1
            end

            if str1:sub(i, i) ~= str2:sub(k, k) then
                transpositions = transpositions + 1
            end

            k = k + 1
        end
    end

    local prefix = 0
    for i = 1, math.min(4, math.min(len1, len2)) do
        if str1:sub(i, i) == str2:sub(i, i) then
            prefix = prefix + 1
        else
            break
        end
    end

    local jaro = (matches / len1 + matches / len2 + (matches - transpositions / 2) / matches) / 3
    local scalingFactor = 0.1
    local jaroWinkler = jaro + prefix * scalingFactor * (1 - jaro)

    return jaroWinkler
end

--- Converts RGB values to a hexadecimal color representation.
--- @param r (number) The red component of the color (0 to 255).
--- @param g (number) The green component of the color (0 to 255).
--- @param b (number) The blue component of the color (0 to 255).
--- @return (string) hex  the hexadecimal representation of the color in the format "#RRGGBB".
function RgbToHex(r, g, b)
    -- Ensure RGB values are within valid range
    r = math.max(0, math.min(255, r))
    g = math.max(0, math.min(255, g))
    b = math.max(0, math.min(255, b))

    -- Convert each component to hexadecimal and concatenate
    return string.format("#%02X%02X%02X", r, g, b)
end

---@param h integer hue
---@param s integer saturation
---@param v integer value
---@return integer r red
---@return integer g green
---@return integer b blue
function HSVToRGB(h, s, v)
    local c = v * s
    local hp = h / 60
    local x = c * (1 - math.abs(hp % 2 - 1))
    local r, g, b = 0, 0, 0

    if hp >= 0 and hp <= 1 then
        r, g, b = c, x, 0
    elseif hp >= 1 and hp <= 2 then
        r, g, b = x, c, 0
    elseif hp >= 2 and hp <= 3 then
        r, g, b = 0, c, x
    elseif hp >= 3 and hp <= 4 then
        r, g, b = 0, x, c
    elseif hp >= 4 and hp <= 5 then
        r, g, b = x, 0, c
    elseif hp >= 5 and hp <= 6 then
        r, g, b = c, 0, x
    end

    local m = v - c
    return math.floor((r + m) * 255), math.floor((g + m) * 255), math.floor((b + m) * 255)
end
