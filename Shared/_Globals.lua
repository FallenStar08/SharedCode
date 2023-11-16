DEBUG_MESSAGES = 3
MOD_ENABLED = true

PersistentVars = {}

Config = {
    initDone = false,
    config_tbl = { MOD_ENABLED = 1 },
    config_json_file_path = "config.json",
    logPath = "log.txt",
    junk_table_json_file_path = "junk_list.json",
    keeplist_json_file_path = "keep_list.json",
    selllist_json_file_path = "sell_list.json",
    CurrentVersion = string.format("%d.%d.%d.%d",
        Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[1],
        Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[2],
        Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[3],
        Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[4]),
}

--For concat function
MAX_PREFIX_LENGTH = 25

--Holds current party
SQUADIES = {}
--Holds summons
SUMMONIES = {}
--Holds party + more
ALLIES = {}
--Generic Pouch
POUCH = "3e6aac21-333b-4812-a554-376c2d157ba9"
--Wither UUID
WITHER = "0133f2ad-e121-4590-b5f0-a79413919805"
--Bag from auto sell root
SELL_ADD_BAG_ROOT = "93165800-7962-4dec-96dc-1310129f6620"
--Gold Root
GOLD = "1c3c9c74-34a1-4685-989e-410dc080be6f"
--Bag from auto sell UUID
SELL_ADD_BAG_ITEM = ""
--Durgy ^_^ may use one day...
DURGY_ROOT = "DragonBorn_Male_OriginIntro_dca00de8-eb34-49b5-b65f-668cdf75116b"

--Colors for print functions
TEXT_COLORS = {
    black = 30,
    red = 31,
    green = 32,
    yellow = 33,
    cyan = 34,
    magenta = 35,
    blue = 36,
    white = 37,
}

--Background Colors for print function
BACKGROUND_COLORS = {
    black = 40,
    red = 41,
    green = 42,
    yellow = 43,
    blue = 44,
    magenta = 45,
    cyan = 46,
    white = 47,
}