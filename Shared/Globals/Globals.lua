--MOD_UUID = ModuleUUID
SE_VERSION = Ext.Utils.Version()

-- CurrentVersion = string.format("%d.%d.%d.%d",
--     Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[1],
--     Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[2],
--     Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[3],
--     Ext.Mod.GetMod(MOD_UUID).Info.ModVersion[4])

PersistentVars = {}
_ = nil
NULLUUID="00000000-0000-0000-0000-000000000000"

Paths = {
    config_json_file_path = "config.json",
    logPath = "log.txt",
    junk_table_json_file_path = "junk_list.json",
    keeplist_json_file_path = "keep_list.json",
    selllist_json_file_path = "sell_list.json",
}

--For concat function
MAX_PREFIX_LENGTH = 25

ORIGINS = {
    ["Wyll"] = "S_Player_Wyll_c774d764-4a17-48dc-b470-32ace9ce447d",
    ["ShadowHeart"] = "S_Player_ShadowHeart_3ed74f06-3c60-42dc-83f6-f034cb47c679",
    ["Laezel"] = "S_Player_Laezel_58a69333-40bf-8358-1d17-fff240d7fb12",
    ["Astarion"] = "S_Player_Astarion_c7c13742-bacd-460a-8f65-f864fe41f255",
    ["Gale"] = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604",
    ["Jaheira"] = "S_Player_Jaheira_91b6b200-7d00-4d62-8dc9-99e8339dfa1a",
    ["Minsc"] = "S_Player_Minsc_0de603c5-42e2-4811-9dad-f652de080eba",
    ["Karlach"] = "S_Player_Karlach_2c76687d-93a2-477b-8b18-8a14b549304c",
    ["Minty"] = "S_GOB_DrowCommander_25721313-0c15-4935-8176-9f134385451b",
    ["BearDude"] = "S_GLO_Halsin_7628bc0e-52b8-42a7-856a-13a6fd413323",
}
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
    ["FALLEN_ARMOR"] = "93d8c08c-9bf9-4049-b80e-9533ec9ff530",
    ["FALLEN_DYE"] = "fe0efdad-d6ee-4a8c-b4ae-a22a6c15bc25",
    ["FALLEN_WEAPON"] = "5ebf8be6-76f9-4b49-a016-a00a03feab58",
    ["FALLEN_VANITY"] = "54e0d178-c5cb-4007-9434-3478ecfb6e1c",
    ["FALLEN_JEWELRY"] = "9ee9383a-5ab2-459f-9ef0-4bcb4c65e3e7",
    ["FALLEN_CLOAK"]= "852e89c3-d861-4ffa-bebc-973e47486918" ,
    ["FALLEN_RANGED"] = "d5843205-c6cd-41e9-9546-9ddb4024116e" ,
    ["FALLEN_BARREL"] = "b888cfbf-8f60-4691-a119-f71011a85252",
    ["FALLEN_QUEST"] = "f801d9c6-0050-4f31-bfdc-4684f606012b",
    ["FALLEN_INSTRUMENT"] = "ed6c96cc-0c33-4f06-8d38-1a458bdc01a2",
}
