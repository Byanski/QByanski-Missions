RegisterNetEvent("QByanski-Mission:client:DailyMissionMenu", function()
    lib.registerMenu({
        id = 'daily_mission_menu',
        title = 'Daily Missions',
        position = 'top-right',
        options = {
            {
                label = 'Get Daily Quests',
                description = 'Daily quests will reset when a new day passes',
                args = { action = 'take' }
            },
            {
                label = 'Check Progress',
                description = "Check your current quest progress",
                args = { action = 'check' }
            },
            {
                label = 'Exit',
                description = "Close Menu",
                args = { action = 'exit' }
            }
        }
    }, function(selected, scrollIndex, args)
        if args.action == 'take' then
            TriggerEvent('QByanski-Missions:client:TakeDailyMission')
        elseif args.action == 'check' then
            TriggerEvent('QByanski-Missions:client:CheckProgress', 'dailymission')
        elseif args.action == 'exit' then
            lib.hideMenu()
        end
    end)

    lib.showMenu('daily_mission_menu')
end)

RegisterNetEvent("QByanski-Mission:client:HourlyMissionMenu", function()
    lib.registerMenu({
        id = 'hourly_mission_menu',
        title = 'Hourly Missions',
        position = 'top-right',
        options = {
            {
                label = 'Get Hourly Quests',
                description = 'Get a new quest every hour',
                args = { event = 'QByanski-Mission:client:TakeHourlyMission' }
            },
            {
                label = 'Check Hourly Quest Progress',
                description = 'Check the progress of your hourly quest',
                args = { event = 'Qbyanski-Missions:client:CheckProgress', mission = 'hourlymission' }
            }
        }
    }, function(selected, scrollIndex, args)
        TriggerEvent(args.event, args.mission)
    end)   
    lib.ShowMenu('hourly_mission_menu')
end)

RegisterNetEvent("QByanski-Mission:client:HiddenMissionMenu", function(data)
    if GetClockHours() >= Config.Hidden_Mission[data.key].min_time and GetClockHours() <= Config.Hidden_Mission[data.key].max_time then
        lib.registerMenu({
            id = 'hidden_mission_menu',
            title = 'Hidden Quests',
            position = 'top-right',
            options = {
                {
                    label = 'Take Quest',
                    description = 'Take the hidden quest',
                    args = { event = 'QByanski-Mission:client:TakeHiddenMission', key = data.key }
                },
                {
                    label = 'Check Current Progress',
                    description = 'Check progress of hidden quest',
                    args = { event = 'QByanski-Mission:client:CheckHiddenProgress', key = data.key }
                }
            }
        }, function(selected, scrollIndex, args)
            TriggerEvent(args.event, args.key)
        end)
        
        lib.showMenu('hidden_mission_menu')
    else
        lib.notify({ description = "I'm busy right now, come back later", type = 'error' })
    end
end)    
