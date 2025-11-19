Config = Config or {}

-- NPC DAILY
Config.Daily_NPC = {
    ped = "a_m_m_farmer_01", -- Changed from cs_orleans to a normal ped
    coords = vector4(174.31, -921.8, 30.69, 64.03),
}

-- NPC HOURLY
Config.Hourly_NPC = {
    ped = "a_m_m_business_01", -- Changed from chimp to a normal ped
    coords = vector4(175.97, -918.58, 30.69, 36.59),
}

-- DAILY MISSION
Config.Daily_Mission = {
    {
        name = "Challenge without using your phone for 1 day",
        label = "Handing over the phone to mom",
        required = {
            ["phone"] = 1,
        },
        reward_item = { -- BONUS PRODUCTS
            ["lockpick"] = 1, 
        }, 
        reward_money = { -- BONUS MONEY
            ["bank"] = 50000,
        }
    },
}

-- HOURLY TASKS
Config.Hourly_Mission = {
    {
        name = "Hardworking Farmer",
        label = "Collect 10 bread, 10 water",
        required = {
            ["sandwich"] = 10,
            ["water_bottle"] = 10,
        },
        reward_item = {
            ["lockpick"] = 2, 
        },
        reward_money = {
            ["cash"] = 5000,
        }
    },
}

-- MYSTERIOUS POINT MISSION
Config.Hidden_Mission = {
    {
        ped = "ig_car3guy1", 
        coords = vector4(136.9, -1046.7, 29.35, 165.69),
        min_time = 10, -- Available from 10 AM
        max_time = 20, -- Available until 8 PM
        id = "hiddenmission", -- Unique ID for this mission
        name = "Black Item",
        label = "Collect USB with encrypted code",
        required = {
            ["cryptostick"] = 10,
        },
        reward_item = {
            ["lockpick"] = 2, 
        },
        reward_money = {
            ["cash"] = 5000,
            ["bank"] = 5000,
        }
    }, 
}