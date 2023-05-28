Citizen.CreateThread(function()
    for i = 1,#Config.Locations.ProjectRP.Braquage do
        for _,v in pairs(Config.Locations.ProjectRP.Braquage[i].Pos) do
            Blips = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
            SetBlipSprite(Blips, 187)
            SetBlipScale(Blips, 0.6)
            SetBlipColour(Blips, 1)
            SetBlipAsShortRange(Blips, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("[ILLÉGAL] | Braquage de banque")
            EndTextCommandSetBlipName(Blips)
        end
    end
end)

RegisterNetEvent("projectrpUtils:AlReadyHoldUP")
AddEventHandler("projectrpUtils:AlReadyHoldUP", function(HoldUP)
    for _,v in pairs(Config.Locations.ProjectRP.Braquage[HoldUP].Pos) do
        v.AlReady = true
    end
end)

RegisterNetEvent("projectrpUtils:OpenDoorHoldUP")
AddEventHandler("projectrpUtils:OpenDoorHoldUP", function(UpdateHoldUP)
    for _,v in pairs(Config.Locations.ProjectRP.Braquage[UpdateHoldUP].Pos) do
        local obs, distance = GetClosestObjectOfType(v.pos.x, v.pos.y, v.pos.z, 1.0, v.type, false, false, false)
        SetEntityHeading(obs, GetEntityHeading(obs)-100)
    end
end)

RegisterNetEvent("projectrpUtils:HoldUPSendAlerte")
AddEventHandler("projectrpUtils:HoldUPSendAlerte", function(coords)
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
    AdvancedNotif("Central", "Information(s)", "Un ~r~braquage de banques~s~ est actuellement en cours... !", "CHAR_CALL911", 1)
    local Blips = AddBlipForCoord(coords)
    SetBlipSprite(Blips, 500)
    SetBlipScale(Blips, 0.75)
    SetBlipColour(Blips, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Braquage de banque en cours")
    EndTextCommandSetBlipName(Blips)
    local BlipsZone = AddBlipForCoord(coords)
    SetBlipSprite(BlipsZone, 161)
    SetBlipScale(BlipsZone, 1.5)
    SetBlipColour(BlipsZone, 1)
    SetBlipShrink(BlipsZone, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zone du braquage de banque")
    EndTextCommandSetBlipName(BlipsZone)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
    Citizen.Wait(75*1000)
    RemoveBlip(Blips)
    RemoveBlip(BlipsZone)
end)