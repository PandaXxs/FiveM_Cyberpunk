CreateThread(function()
    for k,v in pairs(Config.Locations) do
        CreateThread(function() 
            local ped, pedSpawned = nil, {}
            while true do
                local sleep = 1500
                local playerPed = cache.ped
                local coords = GetEntityCoords(playerPed)
                for j, l in pairs(v.LocationVehicule) do
                    local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(l.pedPos.x, l.pedPos.y, l.pedPos.z))
                    if dist <= 30 and not pedSpawned[j] then
                        lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
                        lib.requestModel(l.ped, 100)
                        ped = CreatePed(28, l.ped, l.pedPos.x, l.pedPos.y, l.pedPos.z-1.0, l.pedHeading, false, false)
                        FreezeEntityPosition(ped, true)
                        SetEntityInvincible(ped, true)
                        SetBlockingOfNonTemporaryEvents(ped, true)
                        TaskPlayAnim(ped, 'mini@strip_club@idles@bouncer@base', 'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                        pedSpawned[j] = true
                    elseif dist <= 2.5 then
                        sleep = 0
                        floatTxt(l.uiMessage, vector3(l.pedPos.x, l.pedPos.y, l.pedPos.z+1.0))
                        if IsControlJustReleased(0, 38) then
                            locationMenu(j)
                            sleep = 1500
                        end
                    elseif dist >= 31 and pedSpawned[j] then
                        local model = GetEntityModel(ped)
                        SetModelAsNoLongerNeeded(model)
                        DeletePed(ped)
                        SetPedAsNoLongerNeeded(ped)
                        RemoveAnimDict('mini@strip_club@idles@bouncer@base')
                        pedSpawned[j] = nil
                    end
                    if dist <= 8 then
                        sleep = 0
                        Draw3DText(l.pedPos.x, l.pedPos.y, l.pedPos.z+1.0, 0.4, l.pedLabel)
                    end
                end
                Wait(sleep)
            end
        end)
    end
end)

CreateThread(function() 
    for k, v in pairs(Config.Locations) do
        for j, l in pairs(v.LocationVehicule) do
            if l.blip then
                CreateBlip(l.pedPos, l.blip.sprite, l.blip.color, tostring(l.blip.label), l.blip.scale)
            end
        end
    end
end)

locationMenu = function(station)

    local data = Config.Locations.ProjectRP.LocationVehicule[station].vehicule

    local Options = {}
    for k,v in pairs(data) do

        local price = v.price and v.price..'$' or 'Gratuit'

        Options[#Options + 1] = {
            title = v.label,
            description = price,
            icon = 'car',
            arrow = true,
            event = 'projectrpUtils:VehicleLocation',
            args = { station = station, model = v.model, price = v.price }
        }
    end
    lib.registerContext({
        id = 'location_menu',
        title = 'Location',
        onExit = function()
            inMenu = false
        end,
        options = Options
    })
    lib.showContext('location_menu')
end

AddEventHandler('projectrpUtils:VehicleLocation', function(data)
    inMenu = false

    local model = data.model
    local spawnLoc = Config.Locations.ProjectRP.LocationVehicule[data.station].vehiculeSpawn
    local spawnHeading = Config.Locations.ProjectRP.LocationVehicule[data.station].vehiculeHeading

    if not IsModelInCdimage(GetHashKey(model)) then
        print('Vehicle model not found: '..model)
        return
    else
        local nearbyVehicles = lib.getNearbyVehicles(vec3(spawnLoc.x, spawnLoc.y, spawnLoc.z), 3.0, true)
        if #nearbyVehicles > 0 then
            TriggerEvent('projectrpUtils:notify', 'Impossible de sortir un véhicule', 'Le point de spawn est obstrué.', 'error')
            return
        end
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Wait(100)
        end
    end

    if not data.price then
        data.price = 0
    end

    lib.requestModel(model, 100)
    TriggerServerEvent('projectrpUtils:spawnVehicle', model, spawnLoc, spawnHeading, data.price)
    TriggerServerEvent('projectrpUtils:pay', data.price)

    SetModelAsNoLongerNeeded(model)
    DoScreenFadeIn(800)
end)