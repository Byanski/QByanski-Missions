CreateThread(function()
    -- DAILY NPC
    RequestModel(Config.Daily_NPC.ped)
    while not HasModelLoaded(Config.Daily_NPC.ped) do Wait(10) end

    local Daily_NPC = CreatePed(4, Config.Daily_NPC.ped, Config.Daily_NPC.coords.x, Config.Daily_NPC.coords.y, Config.Daily_NPC.coords.z - 0.5, Config.Daily_NPC.coords.w, false, true)
    FreezeEntityPosition(Daily_NPC, true)
    SetEntityInvincible(Daily_NPC, true)
    SetBlockingOfNonTemporaryEvents(Daily_NPC, true)

    exports.ox_target:addLocalEntity(Daily_NPC, {
        {
            label = '🗞 Talk to Daily Mission NPC',
            icon = 'fa-solid fa-book',
            onSelect = function()
                TriggerEvent("QByanski-Mission:client:DailyMissionMenu")
            end
        }
    })

    -- HOURLY NPC
    RequestModel(Config.Hourly_NPC.ped)
    while not HasModelLoaded(Config.Hourly_NPC.ped) do Wait(10) end

    local Hourly_NPC = CreatePed(4, Config.Hourly_NPC.ped, Config.Hourly_NPC.coords.x, Config.Hourly_NPC.coords.y, Config.Hourly_NPC.coords.z - 1.0, Config.Hourly_NPC.coords.w, false, true)
    FreezeEntityPosition(Hourly_NPC, true)
    SetEntityInvincible(Hourly_NPC, true)
    SetBlockingOfNonTemporaryEvents(Hourly_NPC, true)

    exports.ox_target:addLocalEntity(Hourly_NPC, {
        {
            label = '⏰ Talk to Hourly Mission NPC',
            icon = 'fa-solid fa-clock',
            onSelect = function()
                TriggerEvent("QByanski-Mission:client:HourlyMissionMenu")
            end
        }
    })

    -- HIDDEN NPCS
    for k, v in pairs(Config.Hidden_Mission) do
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped) do Wait(10) end

        local Hidden_NPC = CreatePed(4, v.ped, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, false, true)
        FreezeEntityPosition(Hidden_NPC, true)
        SetEntityInvincible(Hidden_NPC, true)
        SetBlockingOfNonTemporaryEvents(Hidden_NPC, true)

        exports.ox_target:addLocalEntity(Hidden_NPC, {
            {
                label = '📙 Talk to Hidden Mission NPC',
                icon = 'fa-solid fa-eye',
                onSelect = function()
                    TriggerEvent("QByanski-Mission:client:HiddenMissionMenu", { key = k })
                end
            }
        })
    end
end)
