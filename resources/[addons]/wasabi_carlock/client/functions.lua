-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local textUI, breakVehLoop = {}, nil

-- Export Functions
function ToggleLock()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if vehicle and DoesEntityExist(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)
        if HasKey(plate, false) and not isDead then
            if not (IsPedInAnyVehicle(cache.ped, false) and (GetVehiclePedIsIn(cache.ped, false) == vehicle)) then
                CreateThread(function()
                    lib.requestAnimDict('anim@heists@keycard@', 100)
                    TaskPlayAnim(cache.ped, 'anim@heists@keycard@', "exit", 24.0, 16.0, 1000, 50, 0, false, false, false)
                    RemoveAnimDict('anim@heists@keycard@')
                end)
                SetVehicleEngineOn(vehicle, true, true, true)
                SetVehicleLights(vehicle, 2)
                Wait(300)
                SetVehicleLights(vehicle, 1)
                Wait(300)
                SetVehicleLights(vehicle, 2)
                Wait(300)
                SetVehicleLights(vehicle, 1)
                SetVehicleEngineOn(vehicle, false, false, false)
                SetVehicleLights(vehicle, 0)
            end
            local lockStatus = GetVehicleDoorLockStatus(vehicle)
            if lockStatus == 1 or lockStatus == 0 then
                TriggerEvent('wasabi_carlock:notify', Strings.vehicle_locked, Strings.vehicle_locked_desc, 'error', 'lock')
                SetVehicleDoorsLocked(vehicle, 2)
            else
                TriggerEvent('wasabi_carlock:notify', Strings.vehicle_unlocked, Strings.vehicle_unlocked_desc, 'success', 'lock-open')
                SetVehicleDoorsLocked(vehicle, 1)
            end
        end
    end
end

exports('ToggleLock', ToggleLock)

function HasKey(plate, target)
    local plate = Trim(plate)
    if not target then
        return lib.callback.await('wasabi_carlock:hasKey', 100, plate, false)
    else
        return lib.callback.await('wasabi_carlock:hasKey', 100, plate, target)
    end
end

exports('HasKey', HasKey)

function GiveKeys(plate, target)
    local plate = Trim(plate)
    if Config.givingKeys.removeKey and target then
        TriggerServerEvent('wasabi_carlock:updateVehicle', plate, 'remove', false)
    end
    if not target then
        TriggerServerEvent('wasabi_carlock:updateVehicle', plate, 'add', false)
    else
        TriggerServerEvent('wasabi_carlock:updateVehicle', plate, 'add', target)
    end
end

exports('GiveKeys', GiveKeys)

function RemoveKeys(plate, target)
    local plate = Trim(plate)
    if not target then
        TriggerServerEvent('wasabi_carlock:updateVehicle', plate, 'remove', false)
    else
        TriggerServerEvent('wasabi_carlock:updateVehicle', plate, 'remove', target)
    end
end

exports('RemoveKeys', RemoveKeys)

function GiveCar(plate, target)
    local plate = Trim(plate)
    if not target then
        TriggerEvent('wasabi_carlock:notify', 'Erreur', 'Pas de joueur à proximité.', 'error')
    else
        TriggerServerEvent('wasabi_carlock:updateVehicleOwner', plate, 'add', target)
        TriggerServerEvent('wasabi_carlock:updateVehicle', plate, 'remove', false)
    end
end

exports('GiveCar', GiveCar)

-- Functions

local function attemptHotwire(vehicle, plate, vehInfo)
    if not DoesEntityExist(vehicle) then return end
    local vehInfo = vehInfo
    local vehClass = GetVehicleClass(vehicle)
    print(vehClass)
    local skillCheck = lib.skillCheck(Config.hotwire.difficulties[vehClass])
    if skillCheck then
        vehInfo.hotwired = true
        TriggerServerEvent('wasabi_carlock:updateVehicle', plate, 'hotwired', false)
        if textUI ~= {} then 
            textUI = {}
            lib.hideTextUI()
        end
    else
        if not vehInfo.failedHotwire then
            vehInfo.failedHotwire = 1
        else
            vehInfo.failedHotwire = vehInfo.failedHotwire + 1
        end
        TriggerServerEvent('wasabi_carlock:updateVehicle', plate, 'failed', false)
    end
    return vehInfo
end

local function searchVehicle(vehicle, plate, _vehInfo)
    if not DoesEntityExist(vehicle) then return end
    local vehInfo = _vehInfo
    if lib.progressCircle({
        label = Config.searchingVehicle.progressLabel,
        duration = Config.searchingVehicle.timeToSearch*1000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            movement = true,
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_player'
        },
    }) then
        local vehSearch = lib.callback.await('wasabi_carlock:searchVehicle', 100, plate)
        if not vehSearch then
            TriggerEvent('wasabi_carlock:notify', Strings.search_nothing_found, Strings.search_nothing_found_desc, 'error')
        elseif vehSearch.type == 'key' then
            vehInfo.keysFound = true
            TriggerEvent('wasabi_carlock:notify', Strings.search_keys_found, Strings.search_keys_found_desc, 'success')
            if textUI ~= {} then
                textUI = {}
                lib.hideTextUI()
            end
        elseif vehSearch.type == 'item' then
            TriggerEvent('wasabi_carlock:notify', Strings.search_item_found, (Strings.search_item_found_desc):format(vehSearch.quantity, vehSearch.label), 'success')
        elseif vehSearch.type == 'account' then
            TriggerEvent('wasabi_carlock:notify', Strings.search_money_found, (Strings.search_money_found_desc):format(vehSearch.quantity), 'success')
        end
        vehInfo.searched = true
        TriggerServerEvent('wasabi_carlock:updateVehicle', plate, 'searched', false)
        return vehInfo
    else
        TriggerEvent('wasabi_carlock:notify', Strings.cancelled_action, Strings.cancelled_action_desc, 'error')
    end
end

function StopEngine(vehicle)
    SetVehicleEngineOn(vehicle, false, true, true)
end

function StartEngine(vehicle)
    SetVehicleEngineOn(vehicle, true, false, false)
end

function BreakVehicleLoop() breakVehLoop = true end


function StartVehicleLoop(vehicle, plate, _vehInfo)
    CreateThread(function()
        local vehInfo = _vehInfo
        while true do
            local sleep = 0
            if IsPedInAnyVehicle(cache.ped, false) then
                if cache.seat ~= -1 then
                    if textUI ~= {} then
                        lib.hideTextUI()
                        textUI = {}
                    end
                    sleep = 500
                else
                    if vehInfo.hotwired or vehInfo.keysFound or breakVehLoop then StartEngine(vehicle) break end
                    local vehClass = GetVehicleClass(vehicle)
                    StopEngine(vehicle)
                    if Config.hotwire.enabled and Config.searchingVehicle.enabled and Config.hotwire.difficulties[vehClass] then
                        if (not vehInfo.failedHotwire or vehInfo.failedHotwire < Config.hotwire.maxAttempts) and not vehInfo.searched then
                            DisableControlAction(0, Config.hotwire.hotkey, true)
                            DisableControlAction(0, Config.searchingVehicle.hotkey, true)
                            if not textUI?.hotwireAndSearch then
                                lib.showTextUI(Config.hotwire.string..' / '..Config.searchingVehicle.string)
                                textUI.hotwireAndSearch = true
                            end
                            if IsDisabledControlJustReleased(0, Config.hotwire.hotkey) then
                                vehInfo = attemptHotwire(vehicle, plate, vehInfo)
                            elseif IsDisabledControlJustReleased(0, Config.searchingVehicle.hotkey) then
                                vehInfo = searchVehicle(vehicle, plate, vehInfo)
                            end
                        elseif not vehInfo.failedHotwire or vehInfo.failedHotwire < Config.hotwire.maxAttempts then
                            DisableControlAction(0, Config.hotwire.hotkey, true)
                            if not textUI?.hotwire then
                                lib.showTextUI(Config.hotwire.string)
                                textUI.hotwire = true
                            end
                            if IsDisabledControlJustReleased(0, Config.hotwire.hotkey) then
                                local vehInfo = attemptHotwire(vehicle, plate, vehInfo)
                            end
                        elseif not vehInfo.searched then
                            DisableControlAction(0, Config.searchingVehicle.hotkey)
                            if not textUI?.searched then
                                lib.showTextUI(Config.searchingVehicle.string)
                                textUI.searched = true
                            end
                            if IsDisabledControlJustReleased(0, Config.searchingVehicle.hotkey) then
                                local vehInfo = searchVehicle(vehicle, plate, vehInfo)
                            end
                        elseif textUI then
                            lib.hideTextUI()
                            textUI = nil
                        end
                    elseif Config.hotwire.enabled and Config.hotwire.difficulties[vehClass] then
                        if not vehInfo.failedHotwire or vehInfo.failedHotwire < Config.hotwire.maxAttempts then
                            DisableControlAction(0, Config.hotwire.hotkey, true)
                            if not textUI?.hotwire then
                                lib.showTextUI(Config.hotwire.string)
                                textUI.hotwire = true
                            end
                            if IsDisabledControlJustReleased(0, Config.hotwire.hotkey) then
                                local vehInfo = attemptHotwire(vehicle, plate, vehInfo)
                            end
                        end
                    elseif Config.searchingVehicle.enabled then
                        if not vehInfo.searched then
                            DisableControlAction(0, Config.searchingVehicle.hotkey)
                            if not textUI?.searched then
                                lib.showTextUI(Config.searchingVehicle.string)
                                textUI.searched = true
                            end
                            if IsDisabledControlJustReleased(0, Config.searchingVehicle.hotkey) then
                                local vehInfo = searchVehicle(vehicle, plate, vehInfo)
                            end
                        end
                    else
                        sleep = 1500
                    end
                end
            else
                if textUI ~= {} then
                    lib.hideTextUI()
                    textUI = {}
                end
                break
            end
            Wait(sleep)
        end
    end)
end

if Config.givingKeys.enabed then
    function GiveKeyMenu()
        local Options = {}
        local coords = GetEntityCoords(cache.ped)
        local vehicle = lib.getClosestVehicle(coords, 10.0, true)
        if not vehicle or not DoesEntityExist(vehicle) then
            TriggerEvent('wasabi_carlock:notify', Strings.no_vehicle_found, Strings.no_vehicle_found_desc, 'error')
        else
            local plate = GetVehicleNumberPlateText(vehicle)
            local hasKey = HasKey(plate, false)
            if not hasKey then
                TriggerEvent('wasabi_carlock:notify', Strings.no_vehicle_found, Strings.no_vehicle_found_desc, 'error')
            else
                local closestPlayers = lib.getNearbyPlayers(coords, 10.0, false)
                if #closestPlayers < 1 then
                    TriggerEvent('wasabi_carlock:notify', Strings.no_one_nearby, Strings.no_one_nearby_desc, 'error')
                    return
                end
                local playerList = {}
                for i=1, #closestPlayers do
                    playerList[#playerList + 1] = {
                        id = GetPlayerServerId(closestPlayers[i].id)
                    }
                end
                local nearbyPlayers = lib.callback.await('wasabi_carlock:getPlayerData', 100, playerList)
                for _,v in pairs(nearbyPlayers) do
                    Options[#Options + 1] = {
                        icon = 'user',
                        label = v.name,
                        description = Strings.player_id..' '..v.id,
                        args = { id= v.id, plate = plate }
                    }
                end
                lib.registerMenu({
                    id = 'give_keys_menu',
                    title = tostring(Trim(plate)),
                    position = Config.givingKeys.menuPosition,
                    options = Options
                }, function(selected, scrollIndex, args)
                    if selected then
                        GiveKeys(args.plate, args.id, true)
                    end
                end)
                lib.showMenu('give_keys_menu')
            end
        end
    end

    function GiveCarMenu(vehicleList)
        local Options = {}
        local coords = GetEntityCoords(cache.ped)
        local vehicle = lib.getClosestVehicle(coords, 10.0, true)
        if not vehicle or not DoesEntityExist(vehicle) then
            TriggerEvent('wasabi_carlock:notify', Strings.no_vehicle_found, Strings.no_vehicle_found_desc, 'error')
        else
            local plate = GetVehicleNumberPlateText(vehicle)
            local hasKey = HasKey(plate, false)
            if not hasKey then
                TriggerEvent('wasabi_carlock:notify', Strings.no_vehicle_found, Strings.no_vehicle_found_desc, 'error')
            else
                local closestPlayers = lib.getNearbyPlayers(coords, 10.0, false)
                if #closestPlayers < 1 then
                    TriggerEvent('wasabi_carlock:notify', Strings.no_one_nearby, Strings.no_one_nearby_desc, 'error')
                    return
                end
                local playerList = {}
                for i=1, #closestPlayers do
                    playerList[#playerList + 1] = {
                        id = GetPlayerServerId(closestPlayers[i].id)
                    }
                end
                local nearbyPlayers = lib.callback.await('wasabi_carlock:getPlayerData', 100, playerList)
                for _,v in pairs(nearbyPlayers) do
                    Options[#Options + 1] = {
                        icon = 'user',
                        label = v.name,
                        description = Strings.player_id..' '..v.id,
                        args = { id= v.id, plate = plate }
                    }
                end
                lib.registerMenu({
                    id = 'give_keys_menu',
                    title = tostring(Trim(plate)),
                    position = Config.givingKeys.menuPosition,
                    options = Options
                }, function(selected, scrollIndex, args)
                    if selected then
                        for _,v in pairs(vehicleList) do
                            if tostring(Trim(v.plate)) == tostring(Trim(args.plate)) then
                                GiveCar(args.plate, args.id, true)
                                TriggerEvent('wasabi_carlock:notify', 'Véhicule', 'Vous avez donnée le véhicule immatriculé: ' .. args.plate, 'success')
                                return
                            end
                        end
                        TriggerEvent('wasabi_carlock:notify', 'Véhicule', 'Vous n\'êtes pas le propriétaire du véhicule immatriculé: ' .. args.plate, 'error')
                    end
                end)
                lib.showMenu('give_keys_menu')
            end
        end
    end 
end

if Config.lockpick.enabled then
    function LockpickVehicle()
        local coords = GetEntityCoords(cache.ped)
        local vehicle = lib.getClosestVehicle(coords, 5.0, false)
        if not vehicle or not DoesEntityExist(vehicle) then
            TriggerEvent('wasabi_carlock:notify', Strings.no_vehicle_found, Strings.no_vehicle_found_lockpick_desc, 'error')
        elseif IsPedInAnyVehicle(cache.ped, false) then
            TriggerEvent('wasabi_carlock:notify', Strings.no_vehicle_found, Strings.no_vehicle_found_lockpick_desc, 'error')
        else
            if GetVehicleDoorLockStatus(vehicle) == 1 or GetVehicleDoorLockStatus(vehicle) == 0 then
                TriggerEvent('wasabi_carlock:notify', Strings.vehicle_not_locked, Strings.vehicle_not_locked_desc, 'error')
            else
                local vehClass = GetVehicleClass(vehicle)
                if not Config.lockpick.difficulties[vehClass] then
                    TriggerEvent('wasabi_carlock:notify', Strings.vehicle_cant_lockpick, Strings.vehicle_cant_lockpick_desc, 'error')
                else
                    local randInt = math.random(1,100)
                    local vehCoords = GetEntityCoords(vehicle)
                    TaskTurnPedToFaceCoord(cache.ped, vehCoords.x, vehCoords.y, vehCoords.z, 2000)
                    Wait(2000)
                    TaskStartScenarioInPlace(cache.ped, 'PROP_HUMAN_PARKING_METER', 0, true)
                    local skillCheck = lib.skillCheck(Config.lockpick.difficulties[vehClass])
                    if skillCheck then
                        SetVehicleDoorsLocked(vehicle, 1)
                        TriggerEvent('wasabi_carlock:notify', Strings.success, Strings.success_lockpick_desc, 'success')
                    else
                        TriggerEvent('wasabi_carlock:notify', Strings.failed, Strings.fail_lockpick_desc, 'error')
                    end
                    ClearPedTasks(cache.ped)
                    if Config.lockpick.chanceOfLoss >= randInt then
                        TriggerServerEvent('wasabi_lockpick:breakLockpick')
                        TriggerEvent('wasabi_carlock:notify', Strings.lockpick_broke, Strings.lockpick_broke_desc, 'error')
                    end
                end
            end
        end
    end
end
