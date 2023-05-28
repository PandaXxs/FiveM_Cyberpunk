-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
ESX = exports[Config.ESXName]:getSharedObject()
disableKeys, inMenu, isBusy, Authorized = nil, nil, nil, nil, nil, nil, nil, nil
local playerLoaded, injury
plyRequests = {}


CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Wait(1000)
    end
    ESX.PlayerData.job = ESX.GetPlayerData().job
    if Config.targetSystem then

        local data = {
            targetType = 'Player',
            options = {
                {
                    event = 'wasabi_delamaintaxi:billCustomer',
                    icon = 'fas fa-file-invoice-dollar',
                    label = Strings.bill_customer,
                    job = 'taxi',
                }
            },
            distance = 1.5
        }
        TriggerEvent('wasabi_delamaintaxi:addTarget', data)

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    local ped = PlayerPedId() -- slower PCs do not seem to be caching ped in ox lib fast enough
	ESX.PlayerData = xPlayer
	playerLoaded = true
    if ESX.PlayerData.job.name == 'taxi' then
        TriggerServerEvent('wasabi_delamaintaxi:requestSync')
    end
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
    Authorized = false
    if job.name == 'taxi' then
        TriggerServerEvent('wasabi_delamaintaxi:requestSync')
    end
end)

-- I am monster thread
CreateThread(function()
    while ESX.PlayerData.job == nil do
        Wait(1000) -- Necessary for some of the loops that use job check in these threads within threads.
    end
    for k,v in pairs(Config.Locations) do
        if v.Blip.Enabled then
            CreateBlip(v.Blip.Coords, v.Blip.Sprite, v.Blip.Color, v.Blip.String, v.Blip.Scale, false)
        end
        if v.BossMenu.Enabled then
            if v.BossMenu?.Target?.enabled then
                local data = {
                    targetType = 'AddBoxZone',
                    identifier = k..'_pdboss',
                    coords = v.BossMenu.Target.coords,
                    heading = v.BossMenu.Target.heading,
                    width = v.BossMenu.Target.width,
                    length = v.BossMenu.Target.length,
                    minZ = v.BossMenu.Target.minZ,
                    maxZ = v.BossMenu.Target.maxZ,
                    job = 'taxi',
                    distance = 2.0,
                    options = {
                        {
                            event = 'wasabi_delamaintaxi:openBossMenu',
                            icon = 'fas fa-briefcase',
                            label = v.BossMenu.Target.label
                        }
                    }
                }
                TriggerEvent('wasabi_delamaintaxi:addTarget', data)
            else
                CreateThread(function()
                    local textUI
                    while true do
                        local sleep = 1500
                        if ESX.PlayerData.job.name == 'taxi' then
                            local coords = GetEntityCoords(cache.ped)
                            local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.BossMenu.Coords.x, v.BossMenu.Coords.y, v.BossMenu.Coords.z))
                            if dist <= v.BossMenu.Distance then
                                if not textUI then
                                    lib.showTextUI(v.BossMenu.Label)
                                    textUI = true
                                end
                                sleep = 0
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
                                        menu.close()
                                    end, {wash = false})
                                end
                            else
                                if textUI then
                                    lib.hideTextUI()
                                    textUI = nil
                                end
                            end
                        end
                        Wait(sleep)
                    end
                end)
            end
        end
        if v.Cloakroom.Enabled then
            CreateThread(function()
                local textUI
                while true do
                    local sleep = 1500
                    if ESX.PlayerData.job.name == 'taxi' then
                        local ped = cache.ped
                        local coords = GetEntityCoords(ped)
                        local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.Cloakroom.Coords.x, v.Cloakroom.Coords.y, v.Cloakroom.Coords.z))
                        if dist <= v.Cloakroom.Range then
                            if not textUI then
                                lib.showTextUI(v.Cloakroom.Label)
                                textUI = true
                            end
                            sleep = 0
                            if IsControlJustReleased(0, 38) then
                                openOutfits(k)
                            end
                        else
                            if textUI then
                                lib.hideTextUI()
                                textUI = nil
                            end
                        end
                    end
                    Wait(sleep)
                end
            end)
        end
        if v.Coffre.Enabled then 
            CreateThread(function()
                local textUI
                while true do
                    local sleep = 1500
                    if ESX.PlayerData.job.name == 'taxi' then
                        local coords = GetEntityCoords(cache.ped)

                        local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.Coffre.Coords.x, v.Coffre.Coords.y, v.Coffre.Coords.z))

                        if dist <= v.Coffre.Distance then
                            if not textUI then
                                lib.showTextUI(v.Coffre.Label)
                                textUI = true
                            end
                            sleep = 0
                            if IsControlJustReleased(0, 38) then
                                exports.ox_inventory:openInventory('stash', {id = 'society_taxi', owner = 'society_taxi'})
                            end
                        else
                            if textUI then
                                lib.hideTextUI()
                                textUI = nil
                            end
                        end
                    end
                    Wait(sleep)
                end
            end)
        end
        if v.TaxiSupplies.Enabled then
            if Config.targetSystem then
                local data = {
                    targetType = 'AddBoxZone',
                    identifier = k..'_taxisup',
                    coords = v.TaxiSupplies.Coords,
                    heading = v.TaxiSupplies.Heading,
                    width = 1.0,
                    length = 1.0,
                    minZ = v.TaxiSupplies.Coords.z-1.5,
                    maxZ = v.TaxiSupplies.Coords.z+1.5,
                    distance = 1.5,
                    options = {
                        {
                            event = 'wasabi_delamaintaxi:TaxiSuppliesMenu',
                            icon = 'fas fa-car',
                            label = Strings.request_supplies_target,
                            taxi = k,
                            job = 'taxi'
                        }
                    }
                }
                TriggerEvent('wasabi_delamaintaxi:addTarget', data)
            end
            CreateThread(function() 
                local pedtaxi, pedtaxiSpawned, textUI
                while true do
                    local sleep = 1500
                    local playerPed = cache.ped
                    local coords = GetEntityCoords(playerPed)
                    local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.TaxiSupplies.Coords.x, v.TaxiSupplies.Coords.y, v.TaxiSupplies.Coords.z))
                    if dist <= 30 and not pedtaxiSpawned then
                        lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
                        lib.requestModel(v.TaxiSupplies.Ped, 100)
                        pedtaxi = CreatePed(28, v.TaxiSupplies.Ped, v.TaxiSupplies.Coords.x, v.TaxiSupplies.Coords.y, v.TaxiSupplies.Coords.z, v.TaxiSupplies.Heading, true, false)
                        FreezeEntityPosition(pedtaxi, true)
                        SetEntityInvincible(pedtaxi, true)
                        SetBlockingOfNonTemporaryEvents(pedtaxi, true)
                        TaskPlayAnim(pedtaxi, 'mini@strip_club@idles@bouncer@base', 'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                        pedtaxiSpawned = true
                    elseif dist <= 2.5 and not Config.targetSystem then
                        if not textUI then
                            lib.showTextUI(Strings.open_shop_ui)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            TaxiSuppliesMenu(k)
                            sleep = 1500
                        end
                    elseif dist >= 2.6 and not Config.targetSystem and textUI then
                        lib.hideTextUI()
                        textUI = false
                    elseif dist >= 31 and pedtaxiSpawned then
                        local model = GetEntityModel(pedtaxi)
                        SetModelAsNoLongerNeeded(model)
                        DeletePed(pedtaxi)
                        SetPedAsNoLongerNeeded(pedtaxi)
                        RemoveAnimDict('mini@strip_club@idles@bouncer@base')
                        pedSpawned = false
                    end
                    Wait(sleep)
                end
            end)
        end
        if v.Vehicles.Enabled then
            CreateThread(function()
                local zone = v.Vehicles.Zone
                local textUI
                while true do
                    local sleep = 1500
                    if ESX.PlayerData.job.name == 'taxi' then
                        local playerPed = cache.ped
                        local coords = GetEntityCoords(playerPed)
                        local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(zone.coords.x, zone.coords.y, zone.coords.z))
                        local dist2 = #(vector3(coords.x, coords.y, coords.z) - vector3(v.Vehicles.Spawn.air.coords.x, v.Vehicles.Spawn.air.coords.y, v.Vehicles.Spawn.air.coords.z))
                        if dist < zone.range + 1 and not inMenu and not IsPedInAnyVehicle(playerPed, false) then
                            sleep = 0
                            if not textUI then
                                lib.showTextUI(zone.label)
                                textUI = true
                            end
                            if IsControlJustReleased(0, 38) then
                                textUI = nil
                                lib.hideTextUI()
                                openVehicleMenu(k)
                                sleep = 1500
                            end
                        elseif dist < zone.range + 1 and not inMenu and IsPedInAnyVehicle(playerPed, false) then
                            sleep = 0
                            if not textUI then
                                textUI = true
                                lib.showTextUI(zone.return_label)
                            end
                            if IsControlJustReleased(0, 38) then
                                textUI = nil
                                lib.hideTextUI()
                                if DoesEntityExist(cache.vehicle) then
                                    DoScreenFadeOut(800)
                                    while not IsScreenFadedOut() do Wait(100) end
                                    SetEntityAsMissionEntity(cache.vehicle, true, true)
                                    if Config.AdvancedParking then
                                        exports['AdvancedParking']:DeleteVehicleOnServer(cache.vehicle, nil, nil)
                                    else
                                        DeleteVehicle(cache.vehicle)
                                    end
                                    DoScreenFadeIn(800)
                                end
                            end
                        elseif dist2 < 10 and IsPedInAnyVehicle(playerPed, false) then
                            sleep = 0
                            if not textUI then
                                textUI = true
                                lib.showTextUI(zone.return_label)
                            end
                            if IsControlJustReleased(0, 38) then
                                textUI = nil
                                lib.hideTextUI()
                                if DoesEntityExist(cache.vehicle) then
                                    DoScreenFadeOut(800)
                                    while not IsScreenFadedOut() do Wait(100) end
                                    SetEntityAsMissionEntity(cache.vehicle, true, true)
                                    if Config.AdvancedParking then
                                        exports['AdvancedParking']:DeleteVehicleOnServer(cache.vehicle, nil, nil)
                                    else
                                        DeleteVehicle(cache.vehicle)
                                    end
                                    SetEntityCoordsNoOffset(playerPed, zone.coords.x, zone.coords.y, zone.coords.z, false, false, false, true)
                                    DoScreenFadeIn(800)
                                end
                            end
                        else
                            if textUI then
                                textUI = nil
                                lib.hideTextUI()
                            end
                        end
                    end
                    Wait(sleep)
                end
            end)
        end
    end
end)

RegisterNetEvent('wasabi_delamaintaxi:syncRequests')
AddEventHandler('wasabi_delamaintaxi:syncRequests', function(_plyRequests, quiet)
    if ESX.PlayerData.job.name == 'taxi' then
        plyRequests = _plyRequests
        if not quiet then
            TriggerEvent('wasabi_delamaintaxi:notify', Strings.assistance_title, Strings.assistance_desc, 'error', 'suitcase-medical')
        end
    end
end)

AddEventHandler('wasabi_delamaintaxi:buyItem', function(data)
    TriggerServerEvent('wasabi_delamaintaxi:restock', data)
end)

AddEventHandler('wasabi_delamaintaxi:openBossMenu', function()
	TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
		menu.close()
	end, {wash = false})
end)

AddEventHandler('wasabi_delamaintaxi:spawnVehicle', function(data)
    inMenu = false
    local model = data.model
    local category = Config.Locations[data.taxi].Vehicles.Options[data.model].category
    local spawnLoc = Config.Locations[data.taxi].Vehicles.Spawn[category]
    if not IsModelInCdimage(GetHashKey(model)) then
        print('Vehicle model not found: '..model)
    else
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Wait(100)
        end
        lib.requestModel(model, 100)
        local vehicle = CreateVehicle(GetHashKey(model), spawnLoc.coords.x, spawnLoc.coords.y, spawnLoc.coords.z, spawnLoc.heading, 1, 0)
        TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
        if Config.customCarlock then
            local plate = GetVehicleNumberPlateText(vehicle)
            addCarKeys(plate)
        end
        SetModelAsNoLongerNeeded(model)
        DoScreenFadeIn(800)
    end
end)

AddEventHandler('wasabi_delamaintaxi:billCustomer', function()
    if ESX.PlayerData.job.name == 'taxi' then
        local player, dist = ESX.Game.GetClosestPlayer()
        if player == -1 or dist > 4.0 then
            TriggerEvent('wasabi_delamaintaxi:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
        else
            local targetId = GetPlayerServerId(player)
            local input = lib.inputDialog('Bill Patient', {'Amount'})
            if not input then return end
            local amount = math.floor(tonumber(input[1]))
            if amount < 1 then
                TriggerEvent('wasabi_delamaintaxi:notify', Strings.invalid_entry, Strings.invalid_entry_desc, 'error')
            elseif Config.billingSystem == 'okok' then
                local data =  {
                    target = targetId,
                    invoice_value = amount,
                    invoice_item = Strings.taxi_services,
                    society = 'society_taxi',
                    society_name = 'taxi',
                    invoice_notes = ''
                }
                TriggerServerEvent('okokBilling:CreateInvoice', data)
            elseif Config.billingSystem == 'pefcl' then
                TriggerServerEvent('wasabi_delamaintaxi:billPlayer', targetId, amount)
            else
                TriggerServerEvent('esx_billing:sendBill', targetId, 'society_taxi', 'taxi', amount)
            end
        end
    end
end)

AddEventHandler('wasabi_delamaintaxi:TaxiSuppliesMenu', function(data)
    TaxiSuppliesMenu(data.taxi)
end)

AddEventHandler('wasabi_delamaintaxi:gItem', function(data)
    gItem(data)
end)

RegisterCommand('taxiJobMenu', function()
    openJobMenu()
end)

AddEventHandler('wasabi_delamaintaxi:taxiJobMenu', function()
    openJobMenu()
end)

AddEventHandler('wasabi_delamaintaxi:announceMenu', function()
    openAnnounceMenu()
end)

AddEventHandler('wasabi_delamaintaxi:announce', function(data)
    if data.type == 'custom' then
        local input = lib.inputDialog('Annonce personalisée', {'Message'})
        if not input then return end
        TriggerServerEvent('wasabi_delamaintaxi:announce', data.type, input[1])
        return
    end
    TriggerServerEvent('wasabi_delamaintaxi:announce', data.type)
end)

TriggerEvent('chat:removeSuggestion', '/taxiJobMenu')

RegisterKeyMapping('taxiJobMenu', Strings.key_map_text, 'keyboard', Config.jobMenu)
