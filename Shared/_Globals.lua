MOD_UUID = ModuleUUID
SE_VERSION = Ext.Utils.Version()

CurrentVersion = string.format("%d.%d.%d.%d",
    Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[1],
    Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[2],
    Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[3],
    Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[4])

PersistentVars = {}
_ = nil

Paths = {
    config_json_file_path = "config.json",
    logPath = "log.txt",
    junk_table_json_file_path = "junk_list.json",
    keeplist_json_file_path = "keep_list.json",
    selllist_json_file_path = "sell_list.json",
}

--For concat function
MAX_PREFIX_LENGTH = 25

--Holds current party
SQUADIES = {}
--Holds summons
SUMMONIES = {}
--Holds party + more
ALLIES = {}
--Generic Wooden Crate
CRATE = "2608a80a-8f97-db81-03ea-23edf96d303d"
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
DURGY_ROOT = "4717779b-e51c-4645-bcbf-5066249b4787"
--Hidey hole
NAKED_DUMMY_2 = "aa772968-b5e0-4441-8d86-2d0506b4aab5"

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

FALLEN_TAGS = {
    ["FALLEN_ARMOR"]="93d8c08c-9bf9-4049-b80e-9533ec9ff530",
    ["FALLEN_DYE"] = "fe0efdad-d6ee-4a8c-b4ae-a22a6c15bc25",
    ["FALLEN_WEAPON"] = "5ebf8be6-76f9-4b49-a016-a00a03feab58",
    ["FALLEN_VANITY"] = "54e0d178-c5cb-4007-9434-3478ecfb6e1c",
    ["FALLEN_JEWELRY"] = "9ee9383a-5ab2-459f-9ef0-4bcb4c65e3e7",
}