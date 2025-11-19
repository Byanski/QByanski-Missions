-- Daily Mission Menu
RegisterNetEvent("QByanski-Mission:client:DailyMissionMenu", function()
    lib.registerContext({
        id = 'daily_mission_menu',
        title = 'Daily Missions',
        options = {
            {
                title = 'Get Daily Quest',
                description = 'Daily quests will reset when a new day passes',
                icon = 'clipboard-list',
                onSelect = function()
                    TriggerEvent('QByanski-Mission:client:TakeDailyMission')
                end
            },
            {
                title = 'Check Progress',
                description = "Check your current quest progress",
                icon = 'chart-line',
                onSelect = function()
                    TriggerEvent('QByanski-Mission:client:CheckProgress', 'dailymission')
                end
            },
        }
    })
    lib.showContext('daily_mission_menu')
end)

-- Hourly Mission Menu
RegisterNetEvent("QByanski-Mission:client:HourlyMissionMenu", function()
    lib.registerContext({
        id = 'hourly_mission_menu',
        title = 'Hourly Missions',
        options = {
            {
                title = 'Get Hourly Quest',
                description = 'Get a new quest every hour',
                icon = 'clock',
                onSelect = function()
                    TriggerEvent('QByanski-Mission:client:TakeHourlyMission')
                end
            },
            {
                title = 'Check Hourly Quest Progress',
                description = 'Check the progress of your hourly quest',
                icon = 'chart-line',
                onSelect = function()
                    TriggerEvent('QByanski-Mission:client:CheckProgress', 'hourlymission')
                end
            }
        }
    })
    lib.showContext('hourly_mission_menu')
end)

-- Hidden Mission Menu
RegisterNetEvent("QByanski-Mission:client:HiddenMissionMenu", function(data)
    local missionData = Config.Hidden_Mission[data.key]
    if not missionData then return end
    
    local currentHour = GetClockHours()
    
    if currentHour >= missionData.min_time and currentHour <= missionData.max_time then
        lib.registerContext({
            id = 'hidden_mission_menu',
            title = 'Hidden Quests',
            options = {
                {
                    title = 'Take Quest',
                    description = 'Take the hidden quest: ' .. missionData.name,
                    icon = 'eye',
                    onSelect = function()
                        TriggerEvent('QByanski-Mission:client:TakeHiddenMission', data.key)
                    end
                },
                {
                    title = 'Check Current Progress',
                    description = 'Check progress of hidden quest',
                    icon = 'chart-line',
                    onSelect = function()
                        TriggerEvent('QByanski-Mission:client:CheckHiddenProgress', data.key)
                    end
                }
            }
        })
        lib.showContext('hidden_mission_menu')
    else
        lib.notify({ 
            description = "I'm busy right now, come back between " .. missionData.min_time .. ":00 and " .. missionData.max_time .. ":00", 
            type = 'error' 
        })
    end
end)