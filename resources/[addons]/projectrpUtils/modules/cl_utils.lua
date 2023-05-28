
-- Drop armes des pnj

local pedindex = {}
function SetWeaponDrops()
    local handle, ped = FindFirstPed()
    local finished = false 
    repeat 
        if not IsEntityDead(ped) then
                pedindex[ped] = {}
        end
        finished, ped = FindNextPed(handle)
    until not finished
    EndFindPed(handle)
    for peds,_ in pairs(pedindex) do
        if peds ~= nil then 
            SetPedDropsWeaponsWhenDead(peds, false) 
        end
    end
end

-- Spawn avion hélico ect

Citizen.CreateThread(function()
    local SCENARIO_TYPES = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL", 
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    }
    local SCENARIO_GROUPS = {
        2017590552,
        2141866469,
        1409640232, 
        "ng_planes",
    }
    local SUPPRESSED_MODELS = {
        "SHAMAL",
        "LUXOR",
        "LUXOR2",
        "JET", 
        "LAZER", 
        "TITAN",
        "BARRACKS",
        "BARRACKS2",
        "CRUSADER", 
        "RHINO",
        "AIRTUG",
        "RIPLEY",
        "CARGOBOB",
        "CARGOBOB2",
        "CARGOBOB3",
        "CARGOBOB4",
        "HYDRA",
    }
    while true do
        for _, sctyp in next, SCENARIO_TYPES do
            SetScenarioTypeEnabled(sctyp, false)
        end
        for _, scgrp in next, SCENARIO_GROUPS do
            SetScenarioGroupEnabled(scgrp, false)
        end
        for _, model in next, SUPPRESSED_MODELS do
            SetVehicleModelIsSuppressed(GetHashKey(model), true)
        end
        Wait(10000)
    end
end)

-- No cops
		
local PosBL = {
    {pos = vector3(406.7928, -1006.758, 29.26582)},
    {pos = vector3(-453.9952, 6004.273, 31.34049)},
}

local WaitZonePDP = 1000
Citizen.CreateThread(function()
    for i = 1, 15 do
        Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
    end
    while true do
        Wait(WaitZonePDP)
        local playerLocalisation = GetEntityCoords(GetPlayerPed(-1))
        for k,v in pairs(PosBL) do
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.pos, true) < 100 then
                WaitZonePDP = 0
                ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
            else
                WaitZonePDP = 1000
            end
        end
    end
end)

-- pas d'armes dans les vehs police ect

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)

-- Anti drive by

function PetrisAdvancedDriveBy()
    local ped = PlayerPedId()
    local inveh = IsPedSittingInAnyVehicle(ped)
    local veh = GetVehiclePedIsUsing(ped)
    local vehspeed = GetEntitySpeed(veh) * 3.6
    if inveh then
        if vehspeed >= 80 then
            SetPlayerCanDoDriveBy(PlayerId(), false)
        else
            SetPlayerCanDoDriveBy(PlayerId(), true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            PetrisAdvancedDriveBy()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if IsPedArmed(PlayerPedId(), 6) then
            DisableControlAction(1, 140, true) --  Désactive les coups de crosse
            DisableControlAction(1, 141, true) --  Désactive les coups de crosse
            DisableControlAction(1, 142, true) --  Désactive les coups de crosse
            if IsAimCamActive() then
                DisableControlAction(1, 22, true) -- Désactive la roulade
            end
        end
        SetPedSuffersCriticalHits(GetPlayerPed(-1), false) -- Désactive les balles tête
        if IsPedArmed(PlayerPedId(), 6) then Citizen.Wait(0) else Citizen.Wait(300) end
    end
end)
