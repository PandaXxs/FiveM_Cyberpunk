-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
ESX = exports[Config.ESXName]:getSharedObject()
disableKeys, inMenu, stretcher, stretcherMoving, isBusy, Authorized = nil, nil, nil, nil, nil, nil, nil, nil
local playerLoaded
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
                    event = 'wasabi_burgershot:billCustomer',
                    icon = 'fas fa-file-invoice-dollar',
                    label = Strings.bill_customer,
                    job = 'burgershot',
                }
            },
            distance = 1.5
        }
        TriggerEvent('wasabi_burgershot:addTarget', data)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    local ped = PlayerPedId() -- slower PCs do not seem to be caching ped in ox lib fast enough
	ESX.PlayerData = xPlayer
	playerLoaded = true
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
    Authorized = false
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
        if v.Coffre.Enabled then 
            CreateThread(function()
                local textUI
                while true do
                    local sleep = 1500
                    if ESX.PlayerData.job.name == 'burgershot' then
                        local coords = GetEntityCoords(cache.ped)

                        local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.Coffre.Coords.x, v.Coffre.Coords.y, v.Coffre.Coords.z))

                        if dist <= v.Coffre.Distance then
                            if not textUI then
                                lib.showTextUI(v.Coffre.Label)
                                textUI = true
                            end
                            sleep = 0
                            if IsControlJustReleased(0, 38) then
                                exports.ox_inventory:openInventory('stash', {id = 'society_burgershot', owner = 'society_burgershot'})
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
        if v.BurgershotSupplies.Enabled then
            if Config.targetSystem then
                local data = {
                    targetType = 'AddBoxZone',
                    identifier = k..'_burgershotsup',
                    coords = v.BurgershotSupplies.Coords,
                    heading = v.BurgershotSupplies.Heading,
                    width = 1.0,
                    length = 1.0,
                    minZ = v.BurgershotSupplies.Coords.z-1.5,
                    maxZ = v.BurgershotSupplies.Coords.z+1.5,
                    distance = 1.5,
                    options = {
                        {
                            event = 'wasabi_burgershot:BurgershotSuppliesMenu',
                            icon = 'fas fa-toolbox',
                            label = Strings.request_supplies_target,
                            burgershot = k,
                            job = 'burgershot'
                        }
                    }
                }
                TriggerEvent('wasabi_burgershot:addTarget', data)
            end
            CreateThread(function() 
                local ped, pedSpawned, textUI
                while true do
                    local sleep = 1500
                    local playerPed = cache.ped
                    local coords = GetEntityCoords(playerPed)
                    local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.BurgershotSupplies.Coords.x, v.BurgershotSupplies.Coords.y, v.BurgershotSupplies.Coords.z))
                    if dist <= 30 and not pedSpawned then
                        lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
                        lib.requestModel(v.BurgershotSupplies.Ped, 100)
                        ped = CreatePed(28, v.BurgershotSupplies.Ped, v.BurgershotSupplies.Coords.x, v.BurgershotSupplies.Coords.y, v.BurgershotSupplies.Coords.z, v.BurgershotSupplies.Heading, false, false)
                        FreezeEntityPosition(ped, true)
                        SetEntityInvincible(ped, true)
                        SetBlockingOfNonTemporaryEvents(ped, true)
                        TaskPlayAnim(ped, 'mini@strip_club@idles@bouncer@base', 'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                        pedSpawned = true
                    elseif dist <= 2.5 and not Config.targetSystem then
                        if not textUI then
                            lib.showTextUI(Strings.open_shop_ui)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            BurgershotSuppliesMenu(k)
                            sleep = 1500
                        end
                    elseif dist >= 2.6 and not Config.targetSystem and textUI then
                        lib.hideTextUI()
                        textUI = false
                    elseif dist >= 31 and pedSpawned then
                        local model = GetEntityModel(ped)
                        SetModelAsNoLongerNeeded(model)
                        DeletePed(ped)
                        SetPedAsNoLongerNeeded(ped)
                        RemoveAnimDict('mini@strip_club@idles@bouncer@base')
                        pedSpawned = false
                    end
                    Wait(sleep)
                end
            end)
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
                    job = 'burgershot',
                    distance = 2.0,
                    options = {
                        {
                            event = 'wasabi_burgershot:openBossMenu',
                            icon = 'fas fa-briefcase',
                            label = v.BossMenu.Target.label
                        }
                    }
                }
                TriggerEvent('wasabi_burgershot:addTarget', data)
            else
                CreateThread(function()
                    local textUI
                    while true do
                        local sleep = 1500
                        if ESX.PlayerData.job.name == 'burgershot' then
                            local coords = GetEntityCoords(cache.ped)
                            local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.BossMenu.Coords.x, v.BossMenu.Coords.y, v.BossMenu.Coords.z))
                            if dist <= v.BossMenu.Distance then
                                if not textUI then
                                    lib.showTextUI(v.BossMenu.Label)
                                    textUI = true
                                end
                                sleep = 0
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent('esx_society:openBossMenu', 'burgershot', function(data, menu)
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
                    if ESX.PlayerData.job.name == 'burgershot' then
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
        if v.Vehicles.Enabled then
            CreateThread(function()
                local zone = v.Vehicles.Zone
                local textUI
                while true do
                    local sleep = 1500
                    if ESX.PlayerData.job.name == 'burgershot' then
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
        CreateThread(function()
            local textUI
            while true do
                local sleep = 1500
                if ESX.PlayerData.job.name == 'burgershot' then
                    local ped = cache.ped
                    local coords = GetEntityCoords(ped)

                    local dist_recolte_viande = #(vector3(coords.x, coords.y, coords.z) - vector3(v.RecolteViande.Coords.x, v.RecolteViande.Coords.y, v.RecolteViande.Coords.z))
                    local dist_recolte_pain = #(vector3(coords.x, coords.y, coords.z) - vector3(v.RecoltePain.Coords.x, v.RecoltePain.Coords.y, v.RecoltePain.Coords.z))
                    local dist_recolte_frite = #(vector3(coords.x, coords.y, coords.z) - vector3(v.RecolteFrites.Coords.x, v.RecolteFrites.Coords.y, v.RecolteFrites.Coords.z))

                    local dist_vente = #(vector3(coords.x, coords.y, coords.z) - vector3(v.Vente.Coords.x, v.Vente.Coords.y, v.Vente.Coords.z))

                    local dist_fab_menu = #(vector3(coords.x, coords.y, coords.z) - vector3(v.FabMenu.Coords.x, v.FabMenu.Coords.y, v.FabMenu.Coords.z))

                    local dist_boisson_menu = #(vector3(coords.x, coords.y, coords.z) - vector3(v.BoissonMenu.Coords.x, v.BoissonMenu.Coords.y, v.BoissonMenu.Coords.z))
                    local dist_dessert_menu = #(vector3(coords.x, coords.y, coords.z) - vector3(v.DessertMenu.Coords.x, v.DessertMenu.Coords.y, v.DessertMenu.Coords.z))

                    
                    if dist_recolte_viande <= v.RecolteViande.Distance and v.RecolteViande.Enabled then
                        if not textUI then
                            lib.showTextUI(v.RecolteViande.Label)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            openRecolteViande(k)
                        end
                    elseif dist_recolte_pain <= v.RecoltePain.Distance and v.RecoltePain.Enabled then
                        if not textUI then
                            lib.showTextUI(v.RecoltePain.Label)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            openRecoltePain(k)
                        end
                    elseif dist_recolte_frite <= v.RecolteFrites.Distance and v.RecolteFrites.Enabled then
                        if not textUI then
                            lib.showTextUI(v.RecolteFrites.Label)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            openRecolteFrites(k)
                        end
                    elseif dist_fab_menu <= v.FabMenu.Distance and v.FabMenu.Enabled then
                        if not textUI then
                            lib.showTextUI(v.FabMenu.Label)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            openFabMenu(k)
                        end
                    elseif dist_boisson_menu <= v.BoissonMenu.Distance and v.BoissonMenu.Enabled then
                        if not textUI then
                            lib.showTextUI(v.BoissonMenu.Label)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            openBoissonMenu(k)
                        end
                    elseif dist_dessert_menu <= v.DessertMenu.Distance and v.DessertMenu.Enabled then
                        if not textUI then
                            lib.showTextUI(v.DessertMenu.Label)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            openDessertMenu(k)
                        end
                    elseif dist_vente <= v.Vente.Distance and v.Vente.Enabled then
                        if not textUI then
                            lib.showTextUI(v.Vente.Label)
                            textUI = true
                        end
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            openVente(k)
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
end)

AddEventHandler('wasabi_burgershot:buyItem', function(data)
    TriggerServerEvent('wasabi_burgershot:restock', data)
end)

AddEventHandler('wasabi_burgershot:openBossMenu', function()
	TriggerEvent('esx_society:openBossMenu', 'burgershot', function(data, menu)
		menu.close()
	end, {wash = false})
end)

AddEventHandler('wasabi_burgershot:spawnVehicle', function(data)
    inMenu = false
    local model = data.model
    local category = Config.Locations[data.burgershot].Vehicles.Options[data.model].category
    local spawnLoc = Config.Locations[data.burgershot].Vehicles.Spawn[category]
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

AddEventHandler('wasabi_burgershot:billCustomer', function(data)
    if ESX.PlayerData.job.name == 'burgershot' then
        local player, dist = ESX.Game.GetClosestPlayer()
        if player == -1 or dist > 4.0 then
            TriggerEvent('wasabi_burgershot:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
        else
            local targetId = GetPlayerServerId(player)
            local input = lib.inputDialog('Bill Patient', {'Amount'})
            if not input then return end
            local amount = math.floor(tonumber(input[1]))
            if amount < 1 then
                TriggerEvent('wasabi_burgershot:notify', Strings.invalid_entry, Strings.invalid_entry_desc, 'error')
            elseif Config.billingSystem == 'okok' then
                local data =  {
                    target = targetId,
                    invoice_value = amount,
                    invoice_item = Strings.burgershot_services,
                    society = 'society_burgershot',
                    society_name = 'burgershot',
                    invoice_notes = ''
                }
                TriggerServerEvent('okokBilling:CreateInvoice', data)
            elseif Config.billingSystem == 'pefcl' then
                TriggerServerEvent('wasabi_burgershot:billPlayer', targetId, amount)
            else
                TriggerServerEvent('esx_billing:sendBill', targetId, 'society_burgershot', 'burgershot', amount)
            end
        end
    end
end)

AddEventHandler('wasabi_burgershot:BurgershotSuppliesMenu', function(data)
    BurgershotSuppliesMenu(data.burgershot)
end)

AddEventHandler('wasabi_burgershot:gItem', function(data)
    gItem(data)
end)

RegisterCommand('burgerJobMenu', function()
    openJobMenu()
end)

AddEventHandler('wasabi_burgershot:burgerJobMenu', function()
    openJobMenu()
end)

AddEventHandler('wasabi_burgershot:announceMenu', function()
    openAnnounceMenu()
end)

AddEventHandler('wasabi_burgershot:announce', function(data)
    if data.type == 'custom' then
        local input = lib.inputDialog('Annonce personalisée', {'Message'})
        if not input then return end
        TriggerServerEvent('wasabi_burgershot:announce', data.type, input[1])
        return
    end
    TriggerServerEvent('wasabi_burgershot:announce', data.type)
end)

AddEventHandler('wasabi_burgershot:menu', function(data)
	if lib.progressCircle({
		duration = 10000,
		position = 'bottom',
		label = 'Fabrication du menu...',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			scenario = 'PROP_HUMAN_PARKING_METER',
		},
	}) then
        TriggerServerEvent('wasabi_burgershot:giveitem', data.menu)
    end
end)

AddEventHandler('wasabi_burgershot:boisson', function(data)
	if lib.progressCircle({
		duration = 1000,
		position = 'bottom',
		label = 'Prend la canette de soda...',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			scenario = 'PROP_HUMAN_PARKING_METER',
		},
	}) then
        TriggerServerEvent('wasabi_burgershot:giveitem', data.item)
    end
end)

AddEventHandler('wasabi_burgershot:dessert', function(data)
	if lib.progressCircle({
		duration = 1000,
		position = 'bottom',
		label = 'Prend un donut et le met dans l\'emballage...',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			scenario = 'PROP_HUMAN_PARKING_METER',
		},
	}) then
        TriggerServerEvent('wasabi_burgershot:giveitem', data.item)
    end
end)

TriggerEvent('chat:removeSuggestion', '/burgerJobMenu')

RegisterKeyMapping('burgerJobMenu', Strings.key_map_text, 'keyboard', Config.jobMenu)
