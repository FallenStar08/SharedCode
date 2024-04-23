---@return table squadies list of the current party members
function GetSquadies()
    local squadies = {}
    local players = Osi.DB_Players:Get(nil)
    for _, player in pairs(players) do
        local pattern = "%f[%A]dummy%f[%A]"
        if not string.find(player[1]:lower(), pattern) then
            table.insert(squadies, GUID(player[1]))
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
            table.insert(summonies, GUID(summon[1]))
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
        table.insert(battlies, GUID(battlies[1]))
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
        if Osi.IsPartyMember(partyMember[1], 1) == 1 then
            table.insert(partyMembers, GUID(partyMember[1]))
        end
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
        if Osi.IsPartyMember(enemy[1], 1) == 0 then
            table.insert(enemies, GUID(enemy[1]))
        end
    end
    if not next(enemies) then return nil end
    return enemies
end

function GetAvatars()
    local avatarsDB = Osi.DB_Avatars:Get(nil)
    local avatars = {}
    for _, avatar in pairs(avatarsDB) do
        table.insert(avatars, GUID(avatar[1]))
    end
    return avatars
end

--Returns all avatars and Origins
function GetEveryoneThatIsRelevant()
    local goodies = {}
    local avatarsDB = Osi.DB_Avatars:Get(nil)
    local originsDB = Osi.DB_Origins:Get(nil)
    for _, avatar in pairs(avatarsDB) do
        goodies[#goodies + 1] = avatar[1]
    end
    for _, origin in pairs(originsDB) do
        goodies[#goodies + 1] = origin[1]
    end
    return goodies
end
