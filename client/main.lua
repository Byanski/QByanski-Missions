local QBCore = exports['qbx_core']:GetCoreObject()

-- When player loads, check mission metadata
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('QByanski-Mission:server:CheckMission', function(data)
        -- Mission data loaded
    end, "dailymission")

    QBCore.Functions.TriggerCallback('QByanski-Mission:server:CheckMission', function(data)
        -- Mission data loaded
    end, "hourlymission")
end)

-- Take Daily Mission
RegisterNetEvent("QByanski-Mission:client:TakeDailyMission", function()
    local playerData = QBCore.Functions.GetPlayerData()
    local current = playerData.metadata["dailymission"]

    if not current or current == 0 then
        local randomMission = math.random(1, #Config.Daily_Mission)
        TriggerServerEvent("QByanski-Mission:server:TakeDailyMission", randomMission)
        Wait(500) -- Small delay to ensure metadata is updated
        TriggerEvent("QByanski-Mission:client:CheckProgress", "dailymission")
    else
        lib.notify({ 
            description = "You have already received a quest. Check your progress!", 
            type = "error" 
        })
    end
end)

-- Take Hourly Mission
RegisterNetEvent("QByanski-Mission:client:TakeHourlyMission", function()
    local playerData = QBCore.Functions.GetPlayerData()
    local current = playerData.metadata["hourlymission"]

    if not current or current == 0 then
        local randomMission = math.random(1, #Config.Hourly_Mission)
        TriggerServerEvent("QByanski-Mission:server:TakeHourlyMission", randomMission)
        Wait(500) -- Small delay to ensure metadata is updated
        TriggerEvent("QByanski-Mission:client:CheckProgress", "hourlymission")
    else
        lib.notify({ 
            description = "You have already received a quest. Check your progress!", 
            type = "error" 
        })
    end
end)

-- Take Hidden Mission
RegisterNetEvent("QByanski-Mission:client:TakeHiddenMission", function(mission)
    local missionData = Config.Hidden_Mission[mission]
    if not missionData then return end
    
    local id = missionData.id
    local playerData = QBCore.Functions.GetPlayerData()

    if not playerData.metadata[id] then
        if not playerData.metadata[id .. "_done"] then
            lib.notify({
                description = "You have received the hidden quest '" .. missionData.name .. "'. " .. missionData.label,
                type = "success",
                duration = 5000
            })
            TriggerServerEvent("QByanski-Mission:server:TakeHiddenMission", id)
            Wait(500)
            TriggerEvent("QByanski-Mission:client:CheckHiddenProgress", mission)
        else
            lib.notify({ 
                description = "You have already completed this hidden quest.", 
                type = "inform" 
            })
        end
    else
        lib.notify({ 
            description = "You already accepted this hidden quest – try completing it!", 
            type = "error" 
        })
    end
end)

-- Check progress for daily/hourly missions
RegisterNetEvent("QByanski-Mission:client:CheckProgress", function(type)
    local playerData = QBCore.Functions.GetPlayerData()

    if type == "dailymission" then
        local id = playerData.metadata["dailymission"]
        if id and id ~= 0 then
            local mission = Config.Daily_Mission[id]
            if mission then
                TriggerServerEvent("QByanski-Mission:server:CheckProgress", "dailymission", mission.required, mission.reward_item, mission.reward_money)
            end
        else
            lib.notify({ 
                description = "You don't have an active daily mission.", 
                type = "error" 
            })
        end
    elseif type == "hourlymission" then
        local id = playerData.metadata["hourlymission"]
        if id and id ~= 0 then
            local mission = Config.Hourly_Mission[id]
            if mission then
                TriggerServerEvent("QByanski-Mission:server:CheckProgress", "hourlymission", mission.required, mission.reward_item, mission.reward_money)
            end
        else
            lib.notify({ 
                description = "You don't have an active hourly mission.", 
                type = "error" 
            })
        end
    end
end)

-- Check progress for hidden missions
RegisterNetEvent("QByanski-Mission:client:CheckHiddenProgress", function(key)
    local mission = Config.Hidden_Mission[key]
    if not mission then return end
    
    local playerData = QBCore.Functions.GetPlayerData()

    if mission and playerData.metadata[mission.id] then
        TriggerServerEvent("QByanski-Mission:server:CheckProgress", mission.id, mission.required, mission.reward_item, mission.reward_money)
    else
        lib.notify({ 
            description = "You haven't accepted this hidden mission yet.", 
            type = "error" 
        })
    end
end)