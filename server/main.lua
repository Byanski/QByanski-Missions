local QBCore = exports['qbx_core']:GetCoreObject()

-- Check mission status callback
QBCore.Functions.CreateCallback('QByanski-Mission:server:CheckMission', function(source, cb, type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        cb(false)
        return
    end
    
    local DailyMission = Player.PlayerData.metadata["dailymission"] or 0
    local HourlyMission = Player.PlayerData.metadata["hourlymission"] or 0
    local HiddenMission = Player.PlayerData.metadata[type]

    if type == "dailymission" then 
        cb(DailyMission)
    elseif type == "hourlymission" then 
        cb(HourlyMission)
    else 
        cb(HiddenMission or false)
    end
end)

-- Take Daily Mission
RegisterNetEvent("QByanski-Mission:server:TakeDailyMission", function(mission)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local time_table = os.date("*t")
    local currentDay = tonumber(time_table.day)
    local savedDay = tonumber(Player.PlayerData.metadata["dailymission_timestamp"] or 0)
    
    if currentDay ~= savedDay then 
        lib.notify(src, { 
            description = "You have received the daily quest: " .. Config.Daily_Mission[mission].name .. ". " .. Config.Daily_Mission[mission].label, 
            type = "success"
        })
        Player.Functions.SetMetaData("dailymission_timestamp", currentDay)
        Player.Functions.SetMetaData("dailymission", mission)
    else 
        lib.notify(src, { 
            description = "You have already received today's quest. Please wait for a new day.", 
            type = "error"
        })
    end
end)

-- Take Hourly Mission
RegisterNetEvent("QByanski-Mission:server:TakeHourlyMission", function(mission)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local time_table = os.date("*t")
    local currentHour = tonumber(time_table.hour)
    local savedHour = tonumber(Player.PlayerData.metadata["hourlymission_timestamp"] or 0)
    
    if currentHour ~= savedHour then
        lib.notify(src, { 
            description = "You have received the hourly quest: " .. Config.Hourly_Mission[mission].name .. ". " .. Config.Hourly_Mission[mission].label, 
            type = "success"
        })
        Player.Functions.SetMetaData("hourlymission_timestamp", currentHour)
        Player.Functions.SetMetaData("hourlymission", mission)
    else 
        lib.notify(src, { 
            description = "You have already accepted this hour's quest. Please wait a little longer.", 
            type = "error"
        }) 
    end
end)

-- Take Hidden Mission
RegisterNetEvent("QByanski-Mission:server:TakeHiddenMission", function(mission)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    if not Player.PlayerData.metadata[mission] then 
        Player.Functions.SetMetaData(mission .. "_done", false)
        Player.Functions.SetMetaData(mission, true)
    end
end)

-- Check Progress
RegisterNetEvent("QByanski-Mission:server:CheckProgress", function(type, requiredTable, RewardItems, RewardMoney)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local text = ""
    local reward_item_text = ""
    local reward_money_text = ""
    local progress = {}
    local progress_text = ""

    if hasMissionItems(src, requiredTable) then 
        completeMission(src, type, RewardItems, RewardMoney)
    else 
        for k, v in pairs(requiredTable) do
            local item = exports.ox_inventory:Search(src, 'count', k)
            progress[k] = item or 0
            
            if progress[k] < v then 
                progress_text = "[" .. progress[k] .. "/" .. v .. "]"
            else 
                progress_text = "Complete"
            end 
            
            local itemLabel = QBCore.Shared.Items[k] and QBCore.Shared.Items[k]["label"] or k
            text = text .. " - " .. itemLabel .. " " .. progress_text .. "<br>"
        end

        for k, v in pairs(RewardItems) do
            local itemLabel = QBCore.Shared.Items[k] and QBCore.Shared.Items[k]["label"] or k
            reward_item_text = reward_item_text .. " - " .. v .. "x " .. itemLabel .. "<br>"
        end

        for k, v in pairs(RewardMoney) do 
            local money_label = k == "cash" and "CASH" or "BANK"
            reward_money_text = reward_money_text .. " - " .. money_label .. ": $" .. v .. "<br>"
        end 

        lib.notify(src, { 
            description = "You have collected:<br>" .. text .. "<br>Rewards:<br>" .. reward_item_text .. reward_money_text, 
            type = "info",
            duration = 8000
        })
    end
end)

-- Check if player has mission items
function hasMissionItems(source, CostItems)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return false end
    
    -- Check if player has all required items
    for k, v in pairs(CostItems) do
        local count = exports.ox_inventory:Search(source, 'count', k)
        if not count or count < v then
            return false    
        end
    end
    
    -- Remove items if player has them all
    for k, v in pairs(CostItems) do
        exports.ox_inventory:RemoveItem(source, k, v)  
    end
    
    return true
end

-- Complete mission and give rewards
function completeMission(source, type, RewardItems, RewardMoney)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Reset mission status
    if type == "dailymission" then 
        Player.Functions.SetMetaData("dailymission", 0)
    elseif type == "hourlymission" then 
        Player.Functions.SetMetaData("hourlymission", 0)
    else 
        Player.Functions.SetMetaData(type .. "_done", true)
    end

    -- Give item rewards
    if RewardItems ~= nil then
        for k, v in pairs(RewardItems) do
            exports.ox_inventory:AddItem(source, k, v)
        end
    end 
    
    -- Give money rewards
    if RewardMoney ~= nil then
        for k, v in pairs(RewardMoney) do 
            Player.Functions.AddMoney(k, v)
        end
    end
    
    lib.notify(src, { 
        description = "Congratulations on completing the quest and getting the reward!", 
        type = "success"
    })
end

-- Admin command to reset missions
QBCore.Commands.Add("resetmission", "Reset player's mission progress", {{name = "id", help = "Player ID (optional)"}}, false, function(source, args)
    local src = source
    
    if args[1] then
        local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
        if Player then
            Player.Functions.SetMetaData("dailymission", 0)
            Player.Functions.SetMetaData("hourlymission", 0)
            Player.Functions.SetMetaData("dailymission_timestamp", 0)
            Player.Functions.SetMetaData("hourlymission_timestamp", 0)
            lib.notify(src, { 
                description = "Has reset the missions for player " .. Player.PlayerData.source, 
                type = "success"
            })
        else
            lib.notify(src, { 
                description = "Player not online", 
                type = "error"
            })
        end
    else
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            lib.notify(src, { 
                description = "Reset your own quests", 
                type = "success"
            })
            Player.Functions.SetMetaData("dailymission", 0)
            Player.Functions.SetMetaData("hourlymission", 0)
            Player.Functions.SetMetaData("dailymission_timestamp", 0)
            Player.Functions.SetMetaData("hourlymission_timestamp", 0)
        end
    end
end, "admin")