local QBCore = exports['qbx_core']:GetCoreObject()

local CanTakeDailyMission = false
local CanTakeHourlyMission = false

-- When player loads, check mission metadata
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('QByanski-Mission:server:CheckMission', function(data)
        CanTakeDailyMission = data
    end, "dailymission")

    QBCore.Functions.TriggerCallback('QByanski-Mission:server:CheckMission', function(data)
        CanTakeHourlyMission = data
    end, "hourlymission")
end)

-- Take Daily Mission
RegisterNetEvent("QByanski-Mission:client:TakeDailyMission", function()
    local playerData = QBCore.Functions.GetPlayerData()
    local current = playerData.metadata["dailymission"]

    if not current or current == 0 then
        QBCore.Functions.TriggerCallback('QByanski-Mission:server:CheckMission', function(data)
            if data then
                local randomMission = math.random(1, #Config.Daily_Mission)
                TriggerServerEvent("QByanski-Mission:server:TakeDailyMission", randomMission)
                TriggerEvent("QByanski-Mission:client:CheckProgress", "dailymission")
            end
        end, "dailymission")
    else
        lib.notify({ description = "You have already received a quest. Check your progress!", type = "error" })
    end
end)

-- Take Hourly Mission
RegisterNetEvent("QByanski-Mission:client:TakeHourlyMission", function()
    local playerData = QBCore.Functions.GetPlayerData()
    local current = playerData.metadata["hourlymission"]

    if not current or current == 0 then
        QBCore.Functions.TriggerCallback('QByanski-Mission:server:CheckMission', function(data)
            if data then
                local randomMission = math.random(1, #Config.Hourly_Mission)
                TriggerServerEvent("QByanski-Mission:server:TakeHourlyMission", randomMission)
                TriggerEvent("QByanski-Mission:client:CheckProgress", "hourlymission")
            end
        end, "hourlymission")
    else
        lib.notify({ description = "You have already received a quest. Check your progress!", type = "error" })
    end
end)

-- Take Hidden Mission
RegisterNetEvent("QByanski-Mission:client:TakeHiddenMission", function(mission)
    local id = Config.Hidden_Mission[mission].id
    local playerData = QBCore.Functions.GetPlayerData()

    if not playerData.metadata[id] then
        if not playerData.metadata[id .. "_done"] then
            lib.notify({
                description = "You have received the hidden quest '" ..
                    Config.Hidden_Mission[mission].name ..
                    "'. This mission requires you to " .. Config.Hidden_Mission[mission].label .. ".",
                type = "success"
            })
            TriggerServerEvent("QByanski-Mission:server:TakeHiddenMission", id)
            TriggerEvent("QByanski-Mission:client:CheckHiddenProgress", mission)
        else
            lib.notify({ description = "You have already completed this hidden quest.", type = "inform" })
        end
    else
        lib.notify({ description = "You already accepted this hidden quest — try completing it!", type = "error" })
    end
end)

-- Check progress for daily/hourly missions
RegisterNetEvent("QByanski-Mission:client:CheckProgress", function(type)
    local playerData = QBCore.Functions.GetPlayerData()

    if type == "dailymission" then
        local id = playerData.metadata["dailymission"]
        local mission = Config.Daily_Mission[id]
        if mission then
            TriggerServerEvent("QByanski-Mission:server:CheckProgress", "dailymission", mission.required, mission.reward_item, mission.reward_money)
        end
    elseif type == "hourlymission" then
        local id = playerData.metadata["hourlymission"]
        local mission = Config.Hourly_Mission[id]
        if mission then
            TriggerServerEvent("QByanski-Mission:server:CheckProgress", "hourlymission", mission.required, mission.reward_item, mission.reward_money)
        end
    end
end)

-- Check progress for hidden missions
RegisterNetEvent("QByanski-Mission:client:CheckHiddenProgress", function(key)
    local mission = Config.Hidden_Mission[key]
    local playerData = QBCore.Functions.GetPlayerData()

    if mission and playerData.metadata[mission.id] then
        TriggerServerEvent("QByanski-Mission:server:CheckProgress", mission.id, mission.required, mission.reward_item, mission.reward_money)
    end
end)
