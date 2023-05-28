-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
ESX = exports[Config.ESXName]:getSharedObject()
disableKeys, inMenu, stretcher, stretcherMoving, toolboxCoords, isBusy, Authorized = nil, nil, nil, nil, nil, nil, nil, nil
local playerLoaded, injury
plyRequests = {}

local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false

CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Wait(1000)
    end
    ESX.PlayerData.job = ESX.GetPlayerData().job
    if Config.targetSystem then
        local data = {
            targetType = 'Model',
            models = {`prop_tool_box_04`},
            options = {
                {
                    event = 'wasabi_mechanic:pickupBag',
                    icon = 'fas fa-hand-paper',
                    label = Strings.pickup_bag_target,
                    job = "mechanic",
                },
                {
                    event = 'wasabi_mechanic:interactBag',
                    icon = 'fas fa-briefcase',
                    label = Strings.interact_bag_target,
                    job = "mechanic",
                },
            },
            distance = 1.5
        }
        TriggerEvent('wasabi_mechanic:addTarget', data)

        local data = {
            targetType = 'Player',
            options = {
                {
                    event = 'wasabi_mechanic:billCustomer',
                    icon = 'fas fa-file-invoice-dollar',
                    label = Strings.bill_customer,
                    job = 'mechanic',
                }
            },
            distance = 1.5
        }
        TriggerEvent('wasabi_mechanic:addTarget', data)

        local data = {
            targetType = 'Vehicle',
            options = {
                {
                    event = 'wasabi_mechanic:repair',
                    icon = 'fas fa-wrench',
                    label = 'Réparer le véhicule',
                    job = 'mechanic',
                },
                {
                    event = "wasabi_mechanic:clean",
                    icon = 'fas fa-soap',
                    label = 'Nettoyer le véhicule',
                    job = 'mechanic',
                },
                {
                    event = "wasabi_mechanic:fourriere",
                    icon = 'fas fa-wrench',
                    label = 'Mise en fourrière',
                    job = 'mechanic',
                },
                {
                    event = "wasabi_mechanic:depVehicle",
                    icon = 'fas fa-wrench',
                    label = 'Déposer/Enlever le véhicule du plateau',
                    job = 'mechanic',
                }
            },
            distance = 1.5
        }
        TriggerEvent('wasabi_mechanic:addTarget', data)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    local ped = PlayerPedId() -- slower PCs do not seem to be caching ped in ox lib fast enough
	ESX.PlayerData = xPlayer
	playerLoaded = true
    if ESX.PlayerData.job.name == 'mechanic' then
        TriggerServerEvent('wasabi_mechanic:requestSync')
    end
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
    Authorized = false
    if job.name == 'mechanic' then
        TriggerServerEvent('wasabi_mechanic:requestSync')
    end
end)

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.Zones) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

function StartNPCJob()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowable()
	local zone = Config.Zones[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

    TriggerEvent('wasabi_mechanic:notify', 'Conduisez jusqu\'à l\'endroit indiqué', '', 'inform')
end

function StopNPCJob(cancel)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	Config.Zones.VehicleDelivery.Type = -1

	NPCOnJob = false
	NPCTargetTowable  = nil
	NPCTargetTowableZone = nil
	NPCHasSpawnedTowable = false
	NPCHasBeenNextToTowable = false

	if cancel then
        TriggerEvent('wasabi_mechanic:notify', 'Mission annulée', '', 'error')
	else
		--TriggerServerEvent('esx_mechanicjob:onNPCJobCompleted')
	end
end

-- Pop NPC mission vehicle when inside area
CreateThread(function()
	while true do
		local Sleep = 1500
        -- DrawMarker(1, Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z, 0, 0, 0, 0, 0, 0, 10.0, 10.0, 1.0, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0)
		if NPCTargetTowableZone and not NPCHasSpawnedTowable then
			Sleep = 0
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if #(coords - zone.Pos) < Config.NPCSpawnDistance then
				local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]

				ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
					NPCTargetTowable = vehicle
				end)

				NPCHasSpawnedTowable = true
			end
		end

		if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
			Sleep = 500
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if #(coords - zone.Pos) < Config.NPCNextToDistance then
				Sleep = 0
                TriggerEvent('wasabi_mechanic:notify', 'Veuillez remorquer le véhicule', '', 'inform')
				NPCHasBeenNextToTowable = true
			end
		end
	Wait(Sleep)
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
                    job = 'mechanic',
                    distance = 2.0,
                    options = {
                        {
                            event = 'wasabi_mechanic:openBossMenu',
                            icon = 'fas fa-briefcase',
                            label = v.BossMenu.Target.label
                        }
                    }
                }
                TriggerEvent('wasabi_police:addTarget', data)
            else
                CreateThread(function()
                    local textUI
                    while true do
                        local sleep = 1500
                        if ESX.PlayerData.job.name == 'mechanic' then
                            local coords = GetEntityCoords(cache.ped)
                            local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.BossMenu.Coords.x, v.BossMenu.Coords.y, v.BossMenu.Coords.z))
                            if dist <= v.BossMenu.Distance then
                                if not textUI then
                                    lib.showTextUI(v.BossMenu.Label)
                                    textUI = true
                                end
                                sleep = 0
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
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
                    if ESX.PlayerData.job.name == 'mechanic' then
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
        if v.MechanicSupplies.Enabled then
            if Config.targetSystem then
                local data = {
                    targetType = 'AddBoxZone',
                    identifier = k..'_mecasup',
                    coords = v.MechanicSupplies.Coords,
                    heading = v.MechanicSupplies.Heading,
                    width = 1.0,
                    length = 1.0,
                    minZ = v.MechanicSupplies.Coords.z-1.5,
                    maxZ = v.MechanicSupplies.Coords.z+1.5,
                    distance = 1.5,
                    options = {
                        {
                            event = 'wasabi_mechanic:MechanicSuppliesMenu',
                            icon = 'fas fa-toolbox',
                            label = Strings.request_supplies_target,
                            bennys = k,
                            job = 'mechanic'
                        }
                    }
                }
                TriggerEvent('wasabi_mechanic:addTarget', data)
            end
            CreateThread(function() 
                local pedMeca, pedMecaSpawned, textUI
                while true do
                    local sleep = 1500
                    local playerPed = cache.ped
                    local coords = GetEntityCoords(playerPed)
                    local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.MechanicSupplies.Coords.x, v.MechanicSupplies.Coords.y, v.MechanicSupplies.Coords.z))
                    if dist <= 30 and not pedMecaSpawned then
                        lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
                        lib.requestModel(v.MechanicSupplies.Ped, 100)
                        pedMeca = CreatePed(28, v.MechanicSupplies.Ped, v.MechanicSupplies.Coords.x, v.MechanicSupplies.Coords.y, v.MechanicSupplies.Coords.z, v.MechanicSupplies.Heading, true, false)
                        FreezeEntityPosition(pedMeca, true)
                        SetEntityInvincible(pedMeca, true)
                        SetBlockingOfNonTemporaryEvents(pedMeca, true)
                        TaskPlayAnim(pedMeca, 'mini@strip_club@idles@bouncer@base', 'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                        pedMecaSpawned = true
                    elseif dist <= 2.5 and not Config.targetSystem then
                        if not textUI then
                            lib.showTextUI(Strings.open_shop_ui)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            MechanicSuppliesMenu(k)
                            sleep = 1500
                        end
                    elseif dist >= 2.6 and not Config.targetSystem and textUI then
                        lib.hideTextUI()
                        textUI = false
                    elseif dist >= 31 and pedMecaSpawned then
                        local model = GetEntityModel(pedMeca)
                        SetModelAsNoLongerNeeded(model)
                        DeletePed(pedMeca)
                        SetPedAsNoLongerNeeded(pedMeca)
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
                    if ESX.PlayerData.job.name == 'mechanic' then
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

RegisterNetEvent('wasabi_mechanic:syncRequests')
AddEventHandler('wasabi_mechanic:syncRequests', function(_plyRequests, quiet)
    if ESX.PlayerData.job.name == 'mechanic' then
        plyRequests = _plyRequests
        if not quiet then
            TriggerEvent('wasabi_mechanic:notify', Strings.assistance_title, Strings.assistance_desc, 'error', 'suitcase-medical')
        end
    end
end)

RegisterNetEvent('wasabi_mechanic:syncObj', function(netObj)
    local obj = NetToObj(netObj)
    deleteObj(obj)
end)

RegisterNetEvent('wasabi_mechanic:usetoolbox', function()
    usetoolbox()
end)

AddEventHandler('wasabi_mechanic:buyItem', function(data)
    TriggerServerEvent('wasabi_mechanic:restock', data)
end)

AddEventHandler('wasabi_mechanic:openBossMenu', function()
	TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
		menu.close()
	end, {wash = false})
end)

AddEventHandler('wasabi_mechanic:spawnVehicle', function(data)
    inMenu = false
    local model = data.model
    local category = Config.Locations[data.bennys].Vehicles.Options[data.model].category
    local spawnLoc = Config.Locations[data.bennys].Vehicles.Spawn[category]
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

AddEventHandler('wasabi_mechanic:billCustomer', function()
    if ESX.PlayerData.job.name == 'mechanic' then
        local player, dist = ESX.Game.GetClosestPlayer()
        if player == -1 or dist > 4.0 then
            TriggerEvent('wasabi_mechanic:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
        else
            local targetId = GetPlayerServerId(player)
            local input = lib.inputDialog('Bill Patient', {'Amount'})
            if not input then return end
            local amount = math.floor(tonumber(input[1]))
            if amount < 1 then
                TriggerEvent('wasabi_mechanic:notify', Strings.invalid_entry, Strings.invalid_entry_desc, 'error')
            elseif Config.billingSystem == 'okok' then
                local data =  {
                    target = targetId,
                    invoice_value = amount,
                    invoice_item = Strings.mechanic_services,
                    society = 'society_mechanic',
                    society_name = 'bennys',
                    invoice_notes = ''
                }
                TriggerServerEvent('okokBilling:CreateInvoice', data)
            elseif Config.billingSystem == 'pefcl' then
                TriggerServerEvent('wasabi_mechanic:billPlayer', targetId, amount)
            else
                TriggerServerEvent('esx_billing:sendBill', targetId, 'society_mechanic', 'Mechanic', amount)
            end
        end
    end
end)

AddEventHandler('wasabi_mechanic:repair', function(data)
    -- Ont vérifie si le joueur à un fixkit dans son inventaire
    print(exports.ox_inventory:Search('count', 'fixkit'))
    if exports.ox_inventory:Search('count', 'fixkit') > 0 then
        -- Animation de réparation
        lib.requestAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), 'mini@repair', 'fixing_a_player', 8.0, -8.0, -1, 1, 0, false, false, false)
        -- QTE FIXKIT --
        if lib.skillCheck({'easy', 'easy', 'easy', 'easy' ,'easy'}) then
            escaped = true
        end
        if escaped then
            Wait(5000)
            -- On répare le véhicule
            SetVehicleFixed(data.entity)
            SetVehicleDeformationFixed(data.entity)
            SetVehicleUndriveable(data.entity, false)
            SetVehicleEngineOn(data.entity, true, true)
            ClearPedTasks(PlayerPedId())
            escaped = false
            TriggerEvent('wasabi_mechanic:notify', Strings.repair_success, Strings.repair_success_desc, 'success')
            TriggerServerEvent('wasabi_mechanic:removeItem', 'fixkit', 1)
        else
            Wait(5000)
            ClearPedTasks(PlayerPedId())
            TriggerEvent('wasabi_mechanic:notify', Strings.repair_failed, Strings.repair_failed_desc, 'error')
            TriggerServerEvent('wasabi_mechanic:removeItem', 'fixkit', 1)
        end
    else
        TriggerEvent('wasabi_mechanic:notify', Strings.no_fixkit, Strings.no_fixkit_desc, 'error')
    end
end)

AddEventHandler('wasabi_mechanic:clean', function(data)
        -- Ont vérifie si le joueur à un cleankit dans son inventaire
        if exports.ox_inventory:Search('count', 'nettoyagekit') > 0 then
            -- Animation de réparation
            TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_MAID_CLEAN', 0, true)
            -- QTE FIXKIT --
            if lib.skillCheck({'easy'}) then
                escaped = true
            end
            if escaped then
                Wait(5000)
                -- On nettoie le véhicule
                SetVehicleDirtLevel(data.entity, 0)
                ClearPedTasks(PlayerPedId())
                escaped = false
                TriggerEvent('wasabi_mechanic:notify', Strings.clean_success, Strings.clean_success_desc, 'success')
                TriggerServerEvent('wasabi_mechanic:removeItem', 'nettoyagekit', 1)
            else
                Wait(5000)
                ClearPedTasks(PlayerPedId())
                TriggerEvent('wasabi_mechanic:notify', Strings.clean_failed, Strings.clean_failed_desc, 'error')
                TriggerServerEvent('wasabi_mechanic:removeItem', 'nettoyagekit', 1)
            end
        else
            TriggerEvent('wasabi_mechanic:notify', Strings.no_cleankit, Strings.no_cleankit_desc, 'error')
        end
end)

AddEventHandler('wasabi_mechanic:fourriere', function(data)
    local playerPed = PlayerPedId()
    if DoesEntityExist(data.entity) then
        if lib.progressCircle({
            duration = 7500,
            position = 'bottom',
            label = 'Mise en fourrière',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                scenario = 'PROP_HUMAN_PARKING_METER',
            },
        }) then
            TriggerEvent('wasabi_mechanic:notify', Strings.vehicle_impounded, Strings.vehicle_impounded_desc, 'success')
            TriggerServerEvent('wasabi_mechanic:deletevehicle')
        else
            TriggerEvent('wasabi_police:notify', Strings.cancelled, Strings.cancelled_desc, 'error')
        end
    else
        TriggerEvent('wasabi_mechanic:notify', Strings.no_vehicle, Strings.no_vehicle_desc, 'error')
    end
end)

AddEventHandler('wasabi_mechanic:deletevehicleee', function(vehicle)
    print(vehicle)
end)

AddEventHandler('wasabi_mechanic:MechanicSuppliesMenu', function(data)
    MechanicSuppliesMenu(data.bennys)
end)

AddEventHandler('wasabi_mechanic:gItem', function(data)
    gItem(data)
end)

AddEventHandler('wasabi_mechanic:interactBag', function()
    interactBag()
end)

AddEventHandler('wasabi_mechanic:pickupBag', function()
    pickupBag()
end)

RegisterCommand('mecaJobMenu', function()
    openJobMenu()
end)

AddEventHandler('wasabi_mechanic:mecaJobMenu', function()
    openJobMenu()
end)

AddEventHandler('wasabi_mechanic:announceMenu', function()
    openAnnounceMenu()
end)

AddEventHandler('wasabi_mechanic:announce', function(data)
    if data.type == 'custom' then
        local input = lib.inputDialog('Annonce personalisée', {'Message'})
        if not input then return end
        TriggerServerEvent('wasabi_mechanic:announce', data.type, input[1])
        return
    end
    TriggerServerEvent('wasabi_mechanic:announce', data.type)
end)

AddEventHandler('wasabi_mechanic:Mission', function(data)
    print(json.encode(data))
    if data.mission then
        NPCOnJob = true
        StartNPCJob()
    else
        NPCOnJob = false
        StopNPCJob(true)
    end 
end)

AddEventHandler('wasabi_mechanic:depVehicle', function(data)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, true)

    local towmodel = 'flatbed'
    local isVehicleTow = IsVehicleModel(vehicle, towmodel)

    if isVehicleTow then
        local targetVehicle = data.entity

        local playerCoords = GetEntityCoords(playerPed)
        local flatbedCoords = GetEntityCoords(vehicle)

        local dist = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - vector3(flatbedCoords.x, flatbedCoords.y, flatbedCoords.z))

        if dist <= 9.0 then
            if CurrentlyTowedVehicle == nil then
                if targetVehicle ~= 0 then
                    if not IsPedInAnyVehicle(playerPed, true) then
                        if vehicle ~= targetVehicle then
                            if lib.progressCircle({
                                duration = 7500,
                                position = 'bottom',
                                label = 'Mise sur le plateau',
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    car = true,
                                },
                                anim = {
                                    scenario = 'PROP_HUMAN_PARKING_METER',
                                },
                            }) then
                                AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                                CurrentlyTowedVehicle = targetVehicle
                                TriggerEvent('wasabi_mechanic:notify', 'Vehicule attaché avec succès !', '', 'success')
        
                                if NPCOnJob then
                                    if NPCTargetTowable == targetVehicle then
                                        TriggerEvent('wasabi_mechanic:notify', 'Veuillez déposer le véhicule à la concession', '', 'success')

                                        Config.Zones.VehicleDelivery.Type = 1
        
                                        if Blips['NPCTargetTowableZone'] then
                                            RemoveBlip(Blips['NPCTargetTowableZone'])
                                            Blips['NPCTargetTowableZone'] = nil
                                        end
        
                                        Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
                                        SetBlipRoute(Blips['NPCDelivery'], true)
                                    end
                                end
                            end
                        else
                            TriggerEvent('wasabi_mechanic:notify', 'Impossible d\'attacher votre propre dépanneuse !', '', 'error')
                        end
                    end
                else
                    TriggerEvent('wasabi_mechanic:notify', 'Il n\'y a pas de véhicule à attacher !', '', 'error')
                end
            else
                if lib.progressCircle({
                    duration = 7500,
                    position = 'bottom',
                    label = 'Retrait du plateau',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                    anim = {
                        scenario = 'PROP_HUMAN_PARKING_METER',
                    },
                }) then

                    AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                    DetachEntity(CurrentlyTowedVehicle, true, true)
        
                    if NPCOnJob then
        
                        local coords = GetEntityCoords(cache.ped)
                        local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z))
        
                        print(dist)
        
                        if dist <= 10 then
                            NPCTargetDeleterZone = true
                        end
        
                        if NPCTargetDeleterZone then
                            if CurrentlyTowedVehicle == NPCTargetTowable then
                                ESX.Game.DeleteVehicle(NPCTargetTowable)
                                TriggerServerEvent('wasabi_mechanic:onNPCJobMissionCompleted')
                                StopNPCJob()
                                NPCTargetDeleterZone = false
                            else
                                TriggerEvent('wasabi_mechanic:notify', 'Ce n\'est pas le bon véhicule !', '', 'error')
                            end
        
                        else
                            TriggerEvent('wasabi_mechanic:notify', 'Vous devez être au bon endroit pour faire cela !', '', 'error')
                        end
                    end
        
                    CurrentlyTowedVehicle = nil
                    TriggerEvent('wasabi_mechanic:notify', 'Vehicule détaché avec succès !', '', 'error')
                end
            end
        else
            TriggerEvent('wasabi_mechanic:notify', 'Vous devez être plus proche du flatbed !', '', 'error')
        end 
    else
        TriggerEvent('wasabi_mechanic:notify', 'Impossible! Vous devez avoir un Flatbed pour ça', '', 'error')
    end
end)

TriggerEvent('chat:removeSuggestion', '/mecaJobMenu')

RegisterKeyMapping('mecaJobMenu', Strings.key_map_text, 'keyboard', Config.jobMenu)
