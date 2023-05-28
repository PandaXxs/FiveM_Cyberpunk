-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

function createBlip(coords, sprite, color, text, scale, flash)
    local x,y,z = table.unpack(coords)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    if flash then
		SetBlipFlashes(blip, true)
	end
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function exportQBHandler(exportName, func)
    AddEventHandler(('__cfx_export_qb-policejob_%s'):format(exportName), function(setCB)
        setCB(func)
    end)
end

local firstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

local addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

function GetVehicleInDirection()
	local coords = GetEntityCoords(cache.ped)
	local inDirection  = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 5.0, 0.0)
	local rayHandle    = StartExpensiveSynchronousShapeTestLosProbe(coords, inDirection, 10, cache.ped, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		local entityCoords = GetEntityCoords(entityHit)
		return entityHit, entityCoords
	end

	return nil
end

function ShowHelpNotification(msg, thisFrame, beep, duration)
	AddTextEntry('HelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('HelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('HelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

function IsHandcuffed()
    return isCuffed
end

exportQBHandler('IsHandcuffed', IsHandcuffed)

function OpenMobileMenu(id, title, options)
    local Options = {}
    for i=1, #options do
        Options[#Options + 1] = {
            icon = (options[i].icon or false),
            label = options[i].title,
            description = (options[i].description or false),
            args = {event = options[i].event, args = (options[i].args or false)}
        }
    end
    lib.registerMenu({
        id = id,
        title = title,
        position = Config.MobileMenu.position,
        options = Options
    }, function(selected, scrollIndex, args)
        if selected then
            TriggerEvent(args.event, (args.args or false))
        end
    end)
    lib.showMenu(id)
end

openOutfits = function(station)
    if Config.skinScript == 'qb' then
        TriggerEvent('qb-clothing:client:openMenu')
    else
        local data = Config.Locations[station].cloakroom.uniforms
        local Options = {
            {
                title = Strings.civilian_wear,
                description = '',
                arrow = false,
                event = 'wasabi_police:changeClothes',
                args = 'civ_wear'
            }
        }
        for i=1, #data do
            if data[i].minGrade and data[i].maxGrade then
                local _job, grade = HasGroup(Config.policeJobs)
                if grade and grade >= data[i].minGrade and grade <= data[i].maxGrade then
                    Options[#Options + 1] = {
                        title = data[i].label,
                        description = '',
                        arrow = false,
                        event = 'wasabi_police:changeClothes',
                        args = {male = data[i].male, female = data[i].female}
                    }
                end 
            else
                Options[#Options + 1] = {
                    title = data[i].label,
                    description = '',
                    arrow = false,
                    event = 'wasabi_police:changeClothes',
                    args = {male = data[i].male, female = data[i].female}
                }
            end
        end
        if Config.MobileMenu.enabled then
            OpenMobileMenu('pd_cloakroom', Strings.cloakroom, Options)
        else
            lib.registerContext({
                id = 'pd_cloakroom',
                title = Strings.cloakroom,
                options = Options
            })
            lib.showContext('pd_cloakroom')
        end
    end
end

exports('openOutfits', openOutfits)

escortPlayer = function(targetId)
    local targetCuffed = lib.callback.await('wasabi_police:isCuffed', 100, targetId)
    if targetCuffed then
        TriggerServerEvent('wasabi_police:escortPlayer', targetId)
    else
        TriggerEvent('wasabi_police:notify', Strings.not_restrained, Strings.not_restrained_desc, 'error')
    end
end

exports('escortPlayer', escortPlayer)

handcuffPlayer = function(targetId)
    if not HasGroup(Config.policeJobs) then return end
    if deathCheck(targetId) then
        TriggerEvent('wasabi_police:notify', Strings.unconcious, Strings.unconcious_desc, 'error')
    else
        TriggerServerEvent('wasabi_police:handcuffPlayer', targetId)
    end
end

local startCuffTimer = function()
    if Config.handcuff.timer and cuffTimer.active then
        ClearTimeout(cuffTimer.timer)
    end
    cuffTimer.active = true
    cuffTimer.timer = SetTimeout(Config.handcuff.timer,function()
        TriggerEvent('wasabi_police:uncuff')
    end)
end

handcuffed = function()
    isCuffed = true
    TriggerServerEvent('wasabi_police:setCuff', true)
    SetEnableHandcuffs(cache.ped, true)
 --   SetEnableBoundAnkles(cache.ped, true)
    SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
    SetPedCanPlayGestureAnims(cache.ped, false)
    FreezeEntityPosition(cache.ped, true)
    lib.requestAnimDict('mp_arresting', 100)
    TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, 3000, 49, 0, 0, 0, 0)
    Wait(3000)
    if not Config.handcuff.freezePlayer then
        FreezeEntityPosition(cache.ped, false)
    end
    if Config.handcuff.timer then
        if cuffTimer.active then
            ClearTimeout(cuffTimer.timer)
        end
        startCuffTimer()
    end
end

uncuffed = function()
    if not isCuffed then return end
    isCuffed = false
    if escorted?.active then
        escorted.active = nil
    end
    TriggerServerEvent('wasabi_police:setCuff', false)
    SetEnableHandcuffs(cache.ped, false)
    DisablePlayerFiring(cache.ped, false)
    SetPedCanPlayGestureAnims(cache.ped, true)
    FreezeEntityPosition(cache.ped, false)
    DisplayRadar(true)
    if Config.handcuff.timer and cuffTimer.active then
        ClearTimeout(cuffTimer.timer)
    end
    Wait(250) -- Only in fivem ;)
    ClearPedTasks(cache.ped)
    ClearPedSecondaryTask(cache.ped)
    if cuffProp and DoesEntityExist(cuffProp) then
        SetEntityAsMissionEntity(cuffProp, true, true)
        DetachEntity(cuffProp)
        DeleteObject(cuffProp)
        cuffProp = nil
    end
end

manageId = function(data)
    local targetId, license = data.targetId, data.license
    local Options = {
        {
            title = Strings.go_back,
            description = '',
            icon = '',
            arrow = false,
            event = 'wasabi_police:checkId',
            args = targetId
        },
        {
            title = Strings.revoke_license,
            description = '',
            icon = '',
            arrow = false,
            event = 'wasabi_police:revokeLicense',
            args = {targetId = targetId, license = license.type}
        },
    }
    if Config.MobileMenu.enabled then
		OpenMobileMenu('pd_manage_id', (license.label or firstToUpper(tostring(license.type))), Options)
	else
        lib.registerContext({
            id = 'pd_manage_id',
            title = (license.label or firstToUpper(tostring(license.type))),
            options = Options,
        })
        lib.showContext('pd_manage_id')
    end
end

openLicenseMenu = function(data)
    local targetId, licenses = data.targetId, data.licenses
    local Options = {
        {
            title = Strings.go_back,
            description = '',
            icon = '',
            arrow = false,
            event = 'wasabi_police:checkId',
            args = targetId
        }
    }
    for i=1, #licenses do
        Options[#Options + 1] = {
            title = (licenses[i].label or firstToUpper(tostring(licenses[i].type))),
            description = '',
            icon = '',
            arrow = true,
            event = 'wasabi_police:manageId',
            args = {targetId = targetId, license = licenses[i]}
        }
    end
    if Config.MobileMenu.enabled then
		OpenMobileMenu('pd_license_check', Strings.licenses, Options)
	else
        lib.registerContext({
            id = 'pd_license_check',
            title = Strings.licenses,
            options = Options
        })
        lib.showContext('pd_license_check')
    end
end

checkPlayerId = function(targetId)
    local data = lib.callback.await('wasabi_police:checkPlayerId', 100, targetId)
    local Options = {
        {
            title = Strings.go_back,
            description = '',
            icon = '',
            arrow = false,
            event = 'wasabi_police:pdJobMenu', 
        },
        {
            title = Strings.name,
            description = data.name,
            icon = 'id-badge',
            arrow = false,
            event = 'wasabi_police:pdJobMenu', 
        },
        {
            title = Strings.job,
            description = data.job,
            icon = 'briefcase',
            arrow = false,
            event = 'wasabi_police:pdJobMenu', 
        },
        {
            title = Strings.job_position,
            description = data.position,
            icon = 'briefcase',
            arrow = false,
            event = 'wasabi_police:pdJobMenu', 
        },
        {
            title = Strings.dob,
            description = data.dob,
            icon = 'cake-candles',
            arrow = false,
            event = 'wasabi_police:pdJobMenu', 
        },
        {
            title = Strings.sex,
            description = data.sex,
            icon = 'venus-mars',
            arrow = false,
            event = 'wasabi_police:pdJobMenu', 
        }
    }
    if data.drunk then
        Options[#Options + 1] = {
            title = Strings.bac,
            description = data.drunk,
            icon = 'champagne-glasses',
            arrow = false,
            event = 'wasabi_police:pdJobMenu', 
        }
    end
    if not data.licenses or #data.licenses < 1 then
        Options[#Options + 1] = {
            title = Strings.licenses,
            description = Strings.no_licenses,
            icon = 'id-card',
            arrow = true,
            event = 'wasabi_police:pdJobMenu',
        }
    else
        Options[#Options + 1] = {
            title = Strings.licenses,
            description = Strings.total_licenses..' '..#data.licenses,
            icon = 'id-card',
            arrow = true,
            event = 'wasabi_police:licenseMenu',
            args = {licenses = data.licenses, targetId = targetId}
        }
    end
    if Config.MobileMenu.enabled then
		OpenMobileMenu('pd_id_check', Strings.id_result_menu, Options)
	else
        lib.registerContext({
            id = 'pd_id_check',
            title = Strings.id_result_menu,
            options = Options
        })
        lib.showContext('pd_id_check')
    end
end

vehicleInfoMenu = function(vehicle)
    if not DoesEntityExist(vehicle) then
        TriggerEvent('wasabi_police:notify', Strings.vehicle_not_found, Strings.vehicle_not_found_desc, 'error')
    else
        local plate = GetVehicleNumberPlateText(vehicle)
        plate = Trim(plate)
        local ownerData = lib.callback.await('wasabi_police:getVehicleOwner', 100, plate)
        local Options = {
            {
                title = Strings.go_back,
                description = '',
                arrow = false,
                event = 'wasabi_police:vehicleInteractions',
            },
            {
                title = Strings.plate,
                description = plate,
                arrow = false,
                event = 'wasabi_police:pdJobMenu',
            }
        }
        if ownerData then
            Options[#Options + 1] = {
                title = Strings.owner,
                description = ownerData,
                arrow = false,
                event = 'wasabi_police:pdJobMenu',
            }
        else
            Options[#Options + 1] = {
                title = Strings.possibly_stolen,
                description = Strings.possibly_stolen_desc,
                arrow = false,
                event = 'wasabi_police:pdJobMenu',
            }
        end
        if Config.MobileMenu.enabled then
            OpenMobileMenu('pd_veh_info_menu', Strings.vehicle_interactions, Options)
        else
            lib.registerContext({
                id = 'pd_veh_info_menu',
                title = Strings.vehicle_interactions,
                options = Options,
            })
            lib.showContext('pd_veh_info_menu')
        end
    end
end

lockpickVehicle = function(vehicle)
    if not DoesEntityExist(vehicle) then
        TriggerEvent('wasabi_police:notify', Strings.vehicle_not_found, Strings.vehicle_not_found_desc, 'error')
    else
        local playerCoords = GetEntityCoords(cache.ped)
        local targetCoords = GetEntityCoords(vehicle)
        local dist = #(playerCoords - targetCoords)
        if dist < 2.5 then
            TaskTurnPedToFaceCoord(cache.ped, targetCoords.x, targetCoords.y, targetCoords.z, 2000)
            Wait(2000)
            if lib.progressCircle({
                duration = 7500,
                position = 'bottom',
                label = Strings.lockpick_progress,
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
                anim = {
                    scenario = 'PROP_HUMAN_PARKING_METER',
                },
            }) then
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                TriggerEvent('wasabi_police:notify', Strings.lockpicked, Strings.lockpicked_desc, 'success')
            else
                TriggerEvent('wasabi_police:notify', Strings.cancelled, Strings.cancelled_desc, 'error')
            end
        else
            TriggerEvent('wasabi_police:notify', Strings.too_far, Strings.too_far_desc, 'error')
        end
    end
end

impoundVehicle = function(vehicle)
    if not DoesEntityExist(vehicle) then
        TriggerEvent('wasabi_police:notify', Strings.vehicle_not_found, Strings.vehicle_not_found_desc, 'error')
    else
        local playerCoords = GetEntityCoords(cache.ped)
        local targetCoords = GetEntityCoords(vehicle)
        local dist = #(playerCoords - targetCoords)
        if dist < 2.5 then
            local driver = GetPedInVehicleSeat(vehicle, -1)
            if driver == 0 then
                SetVehicleDoorsLocked(vehicle, 2)
                SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                TaskTurnPedToFaceCoord(cache.ped, targetCoords.x, targetCoords.y, targetCoords.z, 2000)
                Wait(2000)
                if lib.progressCircle({
                    duration = 7500,
                    position = 'bottom',
                    label = Strings.impounding_progress,
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                    anim = {
                        scenario = 'PROP_HUMAN_PARKING_METER',
                    },
                }) then
                    impoundSuccessful(vehicle)
                else
                    TriggerEvent('wasabi_police:notify', Strings.cancelled, Strings.cancelled_desc, 'error')
                end
            else
                TriggerEvent('wasabi_police:notify', Strings.driver_in_car, Strings.driver_in_car_desc, 'error')
            end
        else
            TriggerEvent('wasabi_police:notify', Strings.too_far, Strings.too_far_desc, 'error')
        end
    end
end

vehicleInteractionMenu = function()
    local Options = {
        {
            title = Strings.go_back,
            description = '',
            arrow = false,
            event = 'wasabi_police:pdJobMenu',
        },
        {
            title = Strings.vehicle_information,
            description = Strings.vehicle_information_desc,
            icon = 'magnifying-glass',
            arrow = false,
            event = 'wasabi_police:vehicleInfo',
        },
        {
            title = Strings.lockpick_vehicle,
            description = Strings.locakpick_vehicle_desc,
            icon = 'lock-open',
            arrow = false,
            event = 'wasabi_police:lockpickVehicle',
        },
        {
            title = Strings.impound_vehicle,
            description = Strings.impound_vehicle_desc,
            icon = 'reply',
            arrow = false,
            event = 'wasabi_police:impoundVehicle',
        },
    }
    if Config.MobileMenu.enabled then
        OpenMobileMenu('pd_veh_menu', Strings.vehicle_interactions, Options)
    else
        lib.registerContext({
            id = 'pd_veh_menu',
            title = Strings.vehicle_interactions,
            options = Options
        })
        lib.showContext('pd_veh_menu')
    end
end

placeObjectsMenu = function()
    if not HasGroup(Config.policeJobs) then return end
    local job, grade = GetGroup()
    local Options = {
        {
            title = Strings.go_back,
            description = '',
            arrow = false,
            event = 'wasabi_police:pdJobMenu',
        },
    }
    for i=1, #Config.Props do 
        local data = Config.Props[i]
        local add = true
        if (data.groups) then 
            local rank = data.groups[job]
            if not (rank and grade >= rank) then 
                add = false
            end
        end
        if (add) then 
            data.arrow = false
            data.event = "wasabi_police:spawnProp"
            data.args = i

            Options[#Options + 1] = data
        end
    end
    if Config.MobileMenu.enabled then
        OpenMobileMenu('pd_object_menu', Strings.vehicle_interactions, Options)
    else
        lib.registerContext({
            id = 'pd_object_menu',
            title = Strings.vehicle_interactions,
            options = Options
        })
        lib.showContext('pd_object_menu')
    end
end

armouryMenu = function(station)
    local data = Config.Locations[station].armoury
    local job, grade = GetGroup()
    local allow = false
    local aData
    if data.jobLock then

        if data.jobLock == job then
            allow = true
        end
    else
        allow = true
    end
    if allow then
        if grade > #data.weapons then
            aData = data.weapons[#data.weapons]
        elseif not data.weapons[grade] then
            print('[wasabi_police] : ARMORY NOT SET UP PROPERLY FOR GRADE: '..grade)
        else
            aData = data.weapons[grade]
        end
        local Options = {}
        for k,v in pairs(aData) do
            Options[#Options + 1] = {
                title = v.label,
                description = '',
                arrow = false,
                event = 'wasabi_police:purchaseArmoury',
                args = { id = station, grade = grade, itemId = k, multiple = false }
            }
            if v.price then
                Options[#Options].description = Strings.currency..addCommas(v.price)
            end
            if v.multiple then
                Options[#Options].args.multiple = true
            end
        end
        if Config.MobileMenu.enabled then
            OpenMobileMenu('pd_armoury', Strings.armoury_menu, Options)
        else
            lib.registerContext({
                id = 'pd_armoury',
                title = Strings.armoury_menu,
                options = Options
            })
            lib.showContext('pd_armoury')
        end
    else
        TriggerEvent('wasabi_police:notify', Strings.no_permission, Strings.no_access_desc, 'error')
    end
end

openVehicleMenu = function(station)
    if not HasGroup(Config.policeJobs) then return end
    local data, grade
    local job, level = GetGroup()
    if level > #Config.Locations[station].vehicles.options then
        grade = #Config.Locations[station].vehicles.options
        data = Config.Locations[station].vehicles.options[#Config.Locations[station].vehicles.options]
    elseif not Config.Locations[station].vehicles.options[level] then
        print('[wasabi_police] : Police garage not set up properly for job grade: '..level)
        return
    else
        grade = level
        data = Config.Locations[station].vehicles.options[level]
    end
    local Options = {}
    for k,v in pairs(data) do
        if v.category == 'land' then
            Options[#Options + 1] = {
                title = v.label,
                description = '',
                icon = 'car',
                arrow = true,
                event = 'wasabi_police:spawnVehicle',
                args = { station = station, model = k, grade = grade }
            }
        elseif v.category == 'land2' then
            Options[#Options + 1] = {
                title = v.label,
                description = '',
                icon = 'car',
                arrow = true,
                event = 'wasabi_police:spawnVehicle',
                args = { station = station, model = k, grade = grade }
            }
        elseif v.category == 'air' then
            Options[#Options + 1] = {
                title = v.label,
                description = '',
                icon = 'helicopter',
                arrow = true,
                event = 'wasabi_police:spawnVehicle',
                args = { station = station, model = k, grade = grade, category = v.category }
            }
        end
    end
    if Config.MobileMenu.enabled then
        OpenMobileMenu('pd_garage_menu', Strings.police_garage, Options)
    else
        lib.registerContext({
            id = 'pd_garage_menu',
            title = Strings.police_garage,
            onExit = function()
                inMenu = false
            end,
            options = Options
        })
        lib.showContext('pd_garage_menu')
    end
end

local lastTackle = 0
attemptTackle = function()
    if not IsPedSprinting(cache.ped) then return end
    local coords = GetEntityCoords(cache.ped)
    local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
    if player and not isBusy and not IsPedInAnyVehicle(cache.ped) and not IsPedInAnyVehicle(GetPlayerPed(player)) and GetGameTimer() - lastTackle > 7 * 1000 then
        if Config.tackle.policeOnly then
            if HasGroup(Config.policeJobs) then
                lastTackle = GetGameTimer()
                TriggerServerEvent('wasabi_police:attemptTackle', GetPlayerServerId(player))
            end
        else
            lastTackle = GetGameTimer()
            TriggerServerEvent('wasabi_police:attemptTackle', GetPlayerServerId(player))
        end
    end
end

getTackled = function(targetId)
    isBusy = true
    local target = GetPlayerPed(GetPlayerFromServerId(targetId))
    lib.requestAnimDict('missmic2ig_11', 100)
    AttachEntityToEntity(cache.ped, target, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
    TaskPlayAnim(cache.ped, 'missmic2ig_11', 'mic_2_ig_11_intro_p_one', 8.0, -8.0, 3000, 0, 0, false, false, false)
    Wait(3000)
    DetachEntity(cache.ped, true, false)
    SetPedToRagdoll(cache.ped, 1000, 1000, 0, 0, 0, 0)
    isRagdoll = true
    Wait(3000)
    isRagdoll = false
    isBusy = false
    RemoveAnimDict('missmic2ig_11')
end

tacklePlayer = function()
    isBusy = true
    lib.requestAnimDict('missmic2ig_11', 100)
    TaskPlayAnim(cache.ped, 'missmic2ig_11', 'mic_2_ig_11_intro_goon', 8.0, -8.0, 3000, 0, 0, false, false, false)
    Wait(3000)
    isBusy = false
    RemoveAnimDict('missmic2ig_11')
end

function GSRTestNearbyPlayer()
    if not HasGroup(Config.policeJobs) then return end
    local coords = GetEntityCoords(cache.ped)
    local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
    if player and not isBusy then
        local serverId = GetPlayerServerId(player)
        local result = lib.callback.await('wasabi_police:gsrTest', 100, serverId)
        if result then
            TriggerEvent('wasabi_police:notify', Strings.positive, Strings.positive_gsr_desc, 'success')
        else
            TriggerEvent('wasabi_police:notify', Strings.negative, Strings.negative_gsr_desc, 'error')
        end
    else
        TriggerEvent('wasabi_police:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
    end
end
