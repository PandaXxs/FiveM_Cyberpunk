-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

function CreateBlip(coords, sprite, color, text, scale, flash)
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

addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

secondsToClock = function(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

isPlayerDead = function(serverId)
	local playerDead
	if not serverId then
		playerDead = isDead or false
	else
		playerDead = lib.callback.await('wasabi_ambulance:isPlayerDead', 100, serverId)
	end
	return playerDead
end

exports('isPlayerDead', isPlayerDead)

DrawGenericTextThisFrame = function()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

RespawnPed = function(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
	if Framework == 'esx' then
		TriggerEvent('esx:onPlayerSpawn')
	else
		TriggerEvent('wasabi_ambulance:onPlayerSpawn')
	end
end

getClosestHospital = function(coords)
	local closestHospital
	local done
	for k,v in pairs(Config.Locations) do
		if not closestHospital then
			closestHospital = v.RespawnPoint
		else
			local oldDist = #(vector3(coords.x, coords.y, coords.z) - vector3(closestHospital.coords.x, closestHospital.coords.y, closestHospital.coords.z))
			local newDist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.RespawnPoint.coords.x, v.RespawnPoint.coords.y, v.RespawnPoint.coords.z))
			if newDist < oldDist then
				closestHospital = v.RespawnPoint
			end
		end
	end
	return closestHospital
end

StartRPDeath = function()
	TriggerServerEvent('wasabi_ambulance:setDeathStatus', false)
	if Framework == 'esx' then
		TriggerEvent('esx:onPlayerSpawn')
	else
		TriggerEvent('wasabi_ambulance:onPlayerSpawn')
	end
	CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Wait(100)
		end
		if Framework == 'esx' then ESX.SetPlayerData('loadout', {}) end
		if Config.removeItemsOnDeath then
			TriggerServerEvent('wasabi_ambulance:removeItemsOnDeath')
		end
		local spawnCoords = getClosestHospital(GetEntityCoords(cache.ped))
		RespawnPed(cache.ped, vector3(spawnCoords.coords.x, spawnCoords.coords.y, spawnCoords.coords.z), spawnCoords.heading)
		lib.requestAnimDict('missarmenian2', 100)
		disableKeys = true
		TaskPlayAnim(cache.ped, 'missarmenian2', 'corpse_search_exit_ped', 8.0, 8.0, -1, 3, 0, 0, 0, 0)
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(1500)
		while IsScreenFadedOut() do
			Wait(100)
		end
		TriggerEvent('wasabi_ambulance:notify', Strings.alive_again, Strings.alive_again_desc, 'error', 'user-nurse')
		Wait(4000)
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Wait(100)
		end
		ClearPedTasks(cache.ped)
		ClearPedBloodDamage(cache.ped)
		disableKeys = false
		DoScreenFadeIn(800)
		if Config?.wasabi_crutch?.crutchOnBleedout?.enabled then
			exports.wasabi_crutch:SetCrutchTime(cache.serverId, Config.wasabi_crutch.crutchOnBleedout.duration)
		end
	end)
end

startDeathAnimation = function(dead)
	if Config.DisableDeathAnimation then return end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetEntityMaxHealth(ped, 200)
	Wait(200)
    SetEntityHealth(ped, 200)
    SetEntityInvincible(ped,true)
	if Framework == 'esx' then
		TriggerEvent('esx_status:set', 'hunger', 500000)
		TriggerEvent('esx_status:set', 'thirst', 500000)
	elseif Framework == 'qb' then
		TriggerServerEvent('QBCore:Server:SetMetaData', 'hunger', 100)
		TriggerServerEvent('QBCore:Server:SetMetaData', 'thirst', 100)
	end
    if Config.MythicHospital then
        TriggerEvent('mythic_hospital:client:RemoveBleed')
        TriggerEvent('mythic_hospital:client:ResetLimbs')
    end
    lib.requestAnimDict('mini@cpr@char_b@cpr_def', 100)
    lib.requestAnimDict('veh@bus@passenger@common@idle_duck', 100)
    TaskPlayAnim(ped, 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 8.0, 8.0, -1, 3, 0, 0, 0, 0)
	if not dead then
		CreateThread(function()
			while isDead do
				local ped = PlayerPedId()
				local sleep = 1500
				if IsPedInAnyVehicle(ped,false) then
					if not IsEntityPlayingAnim(ped, "veh@bus@passenger@common@idle_duck", "sit", 3) then
						sleep = 0
						ClearPedTasks(ped)
						TaskPlayAnim(ped, "veh@bus@passenger@common@idle_duck", "sit", 8.0, -8, -1, 2, 0, 0, 0, 0)
					end
				else
					if not IsEntityPlayingAnim(ped, 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 3) then
						if not IsEntityPlayingAnim(ped, 'nm', 'firemans_carry', 33) 
						and not IsEntityPlayingAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 33) -- If on the stretcher
						and not IsEntityPlayingAnim(ped, 'anim@arena@celeb@flat@paired@no_props@', 'piggyback_c_player_b', 33) then -- If being /piggyback
							sleep = 0
							ClearPedTasks(ped)
							TaskPlayAnim(ped, 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 8.0, 8.0, -1, 3, 0, 0, 0, 0)
						end
					end
				end
				Wait(sleep)
			end
		end)
	end
    RemoveAnimDict('mini@cpr@char_b@cpr_def')
    RemoveAnimDict('veh@bus@passenger@common@idle_duck')
end

OnPlayerDeath = function()
	if not isDead then
		isDead = true
		if Framework == 'esx' then ESX.UI.Menu.CloseAll() end
		TriggerServerEvent('wasabi_ambulance:setDeathStatus', true)
		Wait(2500)
		startDeathTimer()
		startDistressSignal()
		startDeathAnimation(false)
		AnimpostfxPlay('DeathFailOut', 0, true)
	else
		startDeathAnimation(true)
		AnimpostfxPlay('DeathFailOut', 0, true)
	end
end

setRoute = function(data)
	local coords = lib.callback.await('wasabi_ambulance:getDeathPos', 100, data.plyId)
	SetNewWaypoint(coords.x, coords.y)
	TriggerEvent('wasabi_ambulance:notify', Strings.route_set_title, Strings.route_set_desc, 'success', 'location-dot')
end

diagnosePatient = function()
	local coords = GetEntityCoords(cache.ped)
	local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 4.0, false)
	if not player then
		TriggerEvent('wasabi_ambulance:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
	else
		local servId = GetPlayerServerId(player)
		local plyInjury = lib.callback.await('wasabi_ambulance:diagnosePatient', 100, servId)
		if not plyInjury then
			TriggerEvent('wasabi_ambulance:notify', Strings.no_injury, Strings.no_injury_desc, 'inform', 'stethoscope')
		else
			TriggerEvent('wasabi_ambulance:notify', Strings.player_injury, (Strings.player_injury_desc):format(Strings[plyInjury]), 'error', 'stethoscope')
		end
	end
end

exports('diagnosePatient', diagnosePatient)


reviveTarget = function()
	local authorized = false
	local jobCheck = PlayerData.job.name
    if Config?.policeCanTreat?.enabled then
		for i=1, #Config.policeCanTreat.jobs do
			if Config.policeCanTreat.jobs[i] == jobCheck then
				authorized = true
			end
		end
	end
    if authorized or jobCheck == Config.ambulanceJob then
		local coords = GetEntityCoords(cache.ped)
		local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 3.0, false)
		if not player then
			TriggerEvent('wasabi_ambulance:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
		elseif not isBusy then
			local quantity = lib.callback.await('wasabi_ambulance:itemCheck', 100, Config.EMSItems.revive.item)
			if quantity > 0 then
				local targetId = GetPlayerServerId(player)
				local isPlyDead = lib.callback.await('wasabi_ambulance:isPlayerDead', 100, targetId)
				if isPlyDead then
					isBusy = true
					local ped = cache.ped
					lib.requestAnimDict('mini@cpr@char_a@cpr_str', 100)
					TriggerEvent('wasabi_ambulance:notify', Strings.player_reviving, Strings.player_reviving_desc, 'success')
					local targetPed = GetPlayerPed(player)
					local tCoords = GetEntityCoords(targetPed)
					TaskTurnPedToFaceCoord(ped, tCoords.x, tCoords.y, tCoords.z, 3000)
					disableKeys = true
					Wait(3000)
					for i=1, 15 do
						Wait(900)
						TaskPlayAnim(ped, 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest', 8.0, -8.0, -1, 0, 0.0, false, false, false)
					end
					disableKeys = nil
					RemoveAnimDict('mini@cpr@char_a@cpr_str')
					isBusy = nil
					TriggerServerEvent('wasabi_ambulance:revivePlayer', targetId)
				else
					TriggerEvent('wasabi_ambulance:notify', Strings.player_not_unconcious, Strings.player_not_unconcious_desc, 'error')
				end
			else
				TriggerEvent('wasabi_ambulance:notify', Strings.player_noitem, Strings.player_noitem_desc, 'error')
			end
		else
			TriggerEvent('wasabi_ambulance:notify', Strings.player_busy, Strings.player_busy_desc, 'error')
		end
	end
end

exports('reviveTarget', reviveTarget)

healTarget = function()
	local coords = GetEntityCoords(cache.ped)
	local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
	if not player then
		local ped = cache.ped
		if lib.progressBar({
			duration = Config.EMSItems.heal.duration,
			label = Strings.healing_self_prog,
			useWhileDead = false,
			canCancel = true,
			disable = {
				car = true,
			},
			anim = {
				dict = 'missheistdockssetup1clipboard@idle_a',
				clip = 'idle_a'
			},
		}) then
			TriggerServerEvent('wasabi_ambulance:healPlayer', cache.serverId)
		else
			TriggerEvent('wasabi_ambulance:notify', Strings.action_cancelled, Strings.action_cancelled_desc, 'error')
		end
	else
		local quantity = lib.callback.await('wasabi_ambulance:itemCheck', 100, Config.EMSItems.heal.item)
		if quantity > 0 then
			local targetId = GetPlayerServerId(player)
			local isPlyDead = lib.callback.await('wasabi_ambulance:isPlayerDead', 100, targetId)
			if not isPlyDead then
				local ped = cache.ped
				TriggerEvent('wasabi_ambulance:notify', Strings.player_healing, Strings.player_healing_desc, 'success')
				lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 100)
				local targetPed = GetPlayerPed(player)
				local tCoords = GetEntityCoords(targetPed)
				TaskTurnPedToFaceCoord(ped, tCoords.x, tCoords.y, tCoords.z, 3000)
				Wait(1000)
				if lib.progressBar({
					duration = Config.EMSItems.heal.duration,
					label = Strings.healing_self_prog,
					useWhileDead = false,
					canCancel = true,
					disable = {
						car = true,
						move = true
					},
					anim = {
						dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
						clip = 'machinic_loop_mechandplayer' 
					},
				}) then
					TriggerServerEvent('wasabi_ambulance:healPlayer', targetId)
				else
					TriggerEvent('wasabi_ambulance:notify', Strings.action_cancelled, Strings.action_cancelled_desc, 'error')
				end
			else
				TriggerEvent('wasabi_ambulance:notify', Strings.player_unconcious, Strings.player_unconcious_desc, 'error')
			end
		else
			TriggerEvent('wasabi_ambulance:notify', Strings.player_noitem, Strings.player_noitem_desc, 'error')
		end
	end
end

exports('healTarget', healTarget)

useSedative = function()
	local coords = GetEntityCoords(cache.ped)
	local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
	if not player then
		TriggerEvent('wasabi_ambulance:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
	else
		local quantity = lib.callback.await('wasabi_ambulance:itemCheck', 100, Config.EMSItems.sedate.item)
		if quantity > 0 then
			TriggerServerEvent('wasabi_ambulance:sedatePlayer', GetPlayerServerId(player))
		else
			TriggerEvent('wasabi_ambulance:notify', Strings.player_noitem, Strings.player_noitem_desc, 'error')
		end
	end
end

exports('useSedative', useSedative)

placeInVehicle = function()
	local coords = GetEntityCoords(cache.ped)
	local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 7.5, false)
	if not player then
		TriggerEvent('wasabi_ambulance:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
	else
		local playerPed = GetPlayerPed(player)
		if not IsPedInAnyVehicle(playerPed) then
			if DoesEntityExist(stretcher) then
				SetEntityAsMissionEntity(stretcher, true, true)
				TriggerServerEvent('wasabi_ambulance:removeObj', ObjToNet(stretcher))
			end
		end
		TriggerServerEvent('wasabi_ambulance:putInVehicle', GetPlayerServerId(player))
	end
end

exports('placeInVehicle', placeInVehicle)

local placedOnStretcher
local stretcherObj
placeOnStretcher = function()
	if isDead and not placedOnStretcher then
		local coords = GetEntityCoords(cache.ped)
		local objHash = `prop_ld_binbag_01`
		local stretcherObj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.5, objHash, false)
		local objCoords = GetEntityCoords(stretcherObj)
		lib.requestAnimDict('anim@gangops@morgue@table@', 100)
		TaskPlayAnim(cache.ped, "anim@gangops@morgue@table@", "body_search", 8.0, 8.0, -1, 33, 0, 0, 0, 0)
		AttachEntityToEntity(cache.ped, stretcherObj, 0, 0, 0.0, 1.0, 195.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)
		placedOnStretcher = true
	elseif placedOnStretcher then
		RemoveAnimDict('anim@gangops@morgue@table@')
		lib.requestAnimDict('mini@cpr@char_b@cpr_def', 100)
		DetachEntity(cache.ped)
		ClearPedTasks(cache.ped)
		placedOnStretcher = false
		stretcherObj = nil
	end
end

loadStretcher = function()
	local coords = GetEntityCoords(cache.ped)
	local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 4.0, false)
	if player then
		local isPlyDead = lib.callback.await('wasabi_ambulance:isPlayerDead', 100, GetPlayerServerId(player))
		if isPlyDead then
			TriggerServerEvent('wasabi_ambulance:placeOnStretcher', GetPlayerServerId(player))
		else
			TriggerEvent('wasabi_ambulance:notify', Strings.player_not_unconcious, Strings.player_not_unconcious_desc, 'error')
		end
	else
		TriggerEvent('wasabi_ambulance:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
	end
end

exports('loadStretcher', loadStretcher)

moveStretcher = function()
	local ped = cache.ped
	stretcherMoving = true
	local textUI
	lib.requestAnimDict('anim@heists@box_carry@', 100)
	AttachEntityToEntity(stretcher, ped, GetPedBoneIndex(ped,  28422), 0.0, -0.9, -0.52, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)
    while IsEntityAttachedToEntity(stretcher, ped) do
        Wait()
        if not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) then
            TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
        end
		if not textUI then
			ShowTextUI(Strings.drop_stretch_ui)
			textUI = true
		end
        if IsPedDeadOrDying(ped) then
            DetachEntity(stretcher, true, true)
			HideTextUI()
			textUI = false
        end
        if IsControlJustPressed(0, 38) then
            DetachEntity(stretcher, true, true)
            ClearPedTasks(ped)
            stretcherMoving = false
			HideTextUI()
			textUI = false
            stretcherPlaced(stretcher)
        end
    end
    RemoveAnimDict('anim@heists@box_carry@')

end

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

openOutfits = function(hospital)
	if Config.skinScript == 'qb' then
		TriggerEvent('qb-clothing:client:openMenu')
	else
		local data = Config.Locations[hospital].Cloakroom.Uniforms
		local Options = {
			{
				title = Strings.civilian_wear,
				description = '',
				arrow = false,
				event = 'wasabi_ambulance:changeClothes',
				args = 'civ_wear'
			}
		}
		for i=1, #data do
			if data[i].minGrade and data[i].maxGrade then
				local _job, grade = HasGroup({Config.ambulanceJob})
				if grade and grade >= data[i].minGrade and grade <= data[i].maxGrade then
					Options[#Options + 1] = {
						title = data[i].label,
						description = '',
						arrow = false,
						event = 'wasabi_ambulance:changeClothes',
						args = {male = data[i].male, female = data[i].female}
					}
				end 
			else
				Options[#Options + 1] = {
					title = data[i].label,
					description = '',
					arrow = false,
					event = 'wasabi_ambulance:changeClothes',
					args = {male = data[i].male, female = data[i].female}
				}
			end
		end
		if Config.MobileMenu.enabled then
			OpenMobileMenu('ems_cloakroom', Strings.cloakroom, Options)
		else
			lib.registerContext({
				id = 'ems_cloakroom',
				title = Strings.cloakroom,
				options = Options
			})
			lib.showContext('ems_cloakroom')
		end
	end
end

exports('openOutfits', openOutfits)

pickupStretcher = function()
	local ped = cache.ped
	local coords = GetEntityCoords(ped)
	local stretchHash = `prop_ld_binbag_01`
	local obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, stretchHash, false)
	local objCoords = GetEntityCoords(obj)
	TaskTurnPedToFaceCoord(ped, objCoords.x, objCoords.y, objCoords.z, 2000)
	local cb = lib.callback.await('wasabi_ambulance:gItem', 100, Config.EMSItems.stretcher)
	if cb then
		TriggerEvent('wasabi_ambulance:notify', Strings.successful, Strings.stretcher_pickup, 'success')
	end
	TriggerServerEvent('wasabi_ambulance:removeObj', ObjToNet(obj))
end

function InteractWithStretcher(obj)
	if not DoesEntityExist(obj) then return end
	local Options = {
		{
			title = Strings.pickup_bag_target,
			arrow = false,
			event = 'wasabi_ambulance:pickupStretcher',
		},
		{
			title = Strings.move_target,
			arrow = false,
			event = 'wasabi_ambulance:moveStretcher',
		},
		{
			title = Strings.place_stretcher_target,
			arrow = false,
			event = 'wasabi_ambulance:loadStretcher',
		}
	}
	if Config.MobileMenu.enabled then
		OpenMobileMenu('interact_stretcher_menu', Strings.stretcher_menu_title, Options)
	else
		lib.registerContext({
			id = 'interact_stretcher_menu',
			title = Strings.stretcher_menu_title,
			options = Options
		})
		lib.showContext('interact_stretcher_menu')
	end
end

stretcherPlaced = function(obj)
	local coords = GetEntityCoords(obj)
	local heading = GetEntityHeading(obj)
	local targetPlaced = false
	local textUI = false
	CreateThread(function()
		while true do
			local sleep = 1500
			if DoesEntityExist(obj) then
				if Config.targetSystem then
					if not targetPlaced then
						local data = {
							targetType = 'AddBoxZone',
							identifier = 'stretcherzone',
							coords = vector3(coords.x, coords.y, coords.z),
							width = 2.5,
							length = 2.5,
							heading = heading,
							minZ = coords.z-5,
							maxZ = coords.z+5,
							options = {
								{
									event = 'wasabi_ambulance:pickupStretcher',
									icon = 'fas fa-ambulance',
									label = Strings.pickup_bag_target,
								},
								{
									event = 'wasabi_ambulance:moveStretcher',
									icon = 'fas fa-ambulance',
									label = Strings.move_target,
									job = Config.ambulanceJob
								},
								{
									event = 'wasabi_ambulance:loadStretcher',
									icon = 'fas fa-ambulance',
									label = Strings.place_stretcher_target,
								},
							},
							job = Config.ambulanceJob,
							distance = 2.5
						}
						TriggerEvent('wasabi_ambulance:addTarget', data)
						targetPlaced = true
					end
				else
					local plyCoords = GetEntityCoords(cache.ped)
					local dist = #(vector3(plyCoords.x, plyCoords.y, plyCoords.z) - vector3(coords.x, coords.y, coords.z))
					if dist <= 2.5 then
						if not textUI then
							ShowTextUI(Strings.interact_stretcher_ui)
							textUI = true
						end
						sleep = 0
						if IsControlJustPressed(0, 38) then
							InteractWithStretcher(obj)
						end
					else
						if textUI then
							HideTextUI()
							textUI = false
						end
					end
				end
			elseif not DoesEntityExist(obj) or stretcherMoving then
				if Config.targetSystem then
					TriggerEvent('wasabi_ambulance:removeTarget', 'stretcherzone')
					targetPlaced = false
					break
				else
					if textUI then
						HideTextUI()
						textUI = false
						break
					end
				end
			end
			Wait(sleep)
		end
	end)
end

useStretcher = function()
	local ped = cache.ped
	local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,2.0,0.5))
	local textUI = false
	lib.requestModel('prop_ld_binbag_01', 100)
	lib.requestAnimDict('anim@heists@box_carry@', 100)
	stretcher = CreateObjectNoOffset('prop_ld_binbag_01', x, y, z, true, false)
	SetModelAsNoLongerNeeded('prop_ld_binbag_01')
	AttachEntityToEntity(stretcher, ped, GetPedBoneIndex(ped,  28422), 0.0, -0.9, -0.52, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)
	while IsEntityAttachedToEntity(stretcher, ped) do
		Wait()
		if not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end
		if not textUI then
			ShowTextUI(Strings.drop_stretch_ui)
			textUI = true
		end
		if IsPedDeadOrDying(ped) then
			RemoveAnimDict('anim@heists@box_carry@')
			DetachEntity(stretcher, true, true)
			HideTextUI()
			textUI = false
		end
		if IsControlJustPressed(0, 38) then
            DetachEntity(stretcher, true, true)
            ClearPedTasks(ped)
			RemoveAnimDict('anim@heists@box_carry@')
			HideTextUI()
			textUI = false
            stretcherPlaced(stretcher)
        end
	end
end

treatPatient = function(injury)
	local coords = GetEntityCoords(cache.ped)
	local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
	if not player then
		TriggerEvent('wasabi_ambulance:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
	elseif HasGroup(Config.ambulanceJob) or Authorized then
		local targetId = GetPlayerServerId(player)
		local plyInjury = lib.callback.await('wasabi_ambulance:diagnosePatient', 100, targetId)
		if plyInjury then
			if plyInjury == injury then
				local ped = cache.ped
				local targetPed = GetPlayerPed(player)
				local tCoords = GetEntityCoords(targetPed)
				TaskTurnPedToFaceCoord(ped, tCoords.x, tCoords.y, tCoords.z, 3000)
				Wait(1000)
				TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Wait(Config.TreatmentTime)
				ClearPedTasks(ped)
				TriggerServerEvent('wasabi_ambulance:treatPlayer', targetId, injury)
			else
				TriggerEvent('wasabi_ambulance:notify', Strings.wrong_equipment, Strings.wrong_equipment_desc, 'error')
			end
		else
			TriggerEvent('wasabi_ambulance:notify', Strings.player_not_injured, Strings.player_not_injured_desc, 'error')
		end
	else
		TriggerEvent('wasabi_ambulance:notify', Strings.not_medic, Strings.not_medic_desc, 'error')
	end
end

exports('treatPatient', treatPatient)

gItem = function(data)
	local item = data.item
	local cb = lib.callback.await('wasabi_ambulance:gItem', 100, item)
	if cb then
		TriggerEvent('wasabi_ambulance:notify', Strings.successful, Strings.item_grab, 'success')
	else
		TriggerEvent('wasabi_ambulance:notify', Strings.successful, Strings.medbag_pickup_civ, 'success')
	end
end

interactBag = function()
	if HasGroup(Config.ambulanceJob) or Authorized then
		local Options = {
			{
				title = Strings.medbag_tweezers,
				description = Strings.medbag_tweezers_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.TreatmentItems.shot}
			},
			{
				title = Strings.medbag_suture,
				description = Strings.medbag_suture_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.TreatmentItems.stabbed}
			},
			{
				title = Strings.medbag_icepack,
				description = Strings.medbag_icepack_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.TreatmentItems.beat}
			},
			{
				title = Strings.medbag_burncream,
				description = Strings.medbag_burncream_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.TreatmentItems.burned}
			},
			{
				title = Strings.medbag_defib,
				description = Strings.medbag_defib_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.EMSItems.revive.item}
			},
			{
				title = Strings.medbag_medikit,
				description = Strings.medbag_medikit_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.EMSItems.heal.item}
			},
			{
				title = Strings.medbag_sedative,
				description = Strings.medbag_sedative_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.EMSItems.sedate.item}
			},
			{
				title = Strings.medbag_stretcher,
				description = Strings.medbag_stretcher_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.EMSItems.stretcher}
			}

		}
		if Config?.wasabi_crutch?.crutchInMedbag?.enabled then
			Options[#Options + 1] = {
				title = Strings.medbag_crutch,
				description = Strings.medbag_crutch_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.wasabi_crutch.crutchInMedbag.item}
			}
		end
		if Config?.wasabi_crutch?.chairInMedbag?.enabled then
			Options[#Options + 1] = {
				title = Strings.medbag_chair,
				description = Strings.medbag_chair_desc,
				arrow = false,
				event = 'wasabi_ambulance:gItem',
				args = {item = Config.wasabi_crutch.chairInMedbag.item}
			}
		end
		if Config.MobileMenu.enabled then
			OpenMobileMenu('medbag', Strings.medbag, Options)
		else
			lib.registerContext({
				id = 'medbag',
				title = Strings.medbag,
				options = Options
			})
			lib.showContext('medbag')
		end
	else
		TriggerEvent('wasabi_ambulance:notify', Strings.not_medic, Strings.not_medic_desc, 'error')
	end
end

deleteObj = function(bag)
	if DoesEntityExist(bag) then
		SetEntityAsMissionEntity(bag, true, true)
		DeleteObject(bag)
		DeleteEntity(bag)
	end
end

pickupBag = function()
	local ped = cache.ped
	local coords = GetEntityCoords(ped)
	local bagHash = `xm_prop_x17_bag_med_01a`
	local closestBag = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, bagHash, false)
	local bagCoords = GetEntityCoords(closestBag)
	TaskTurnPedToFaceCoord(ped, bagCoords.x, bagCoords.y, bagCoords.z, 2000)
	TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, 8.0, 1000, 50, 0, false, false, false)
	Wait(1000)
	TriggerServerEvent('wasabi_ambulance:removeObj', ObjToNet(closestBag))
	Wait(500)
	if not DoesEntityExist(closestBag) then
		local cb = lib.callback.await('wasabi_ambulance:gItem', 100, Config.EMSItems.medbag)
		if cb then
			TriggerEvent('wasabi_ambulance:notify', Strings.successful, Strings.medbag_pickup, 'success')
		else
			TriggerEvent('wasabi_ambulance:notify', Strings.successful, Strings.medbag_pickup_civ, 'success')
		end
	end
end

medicalSuppliesMenu = function(id)
	if HasGroup(Config.ambulanceJob) then
		local supplies = Config.Locations[id].MedicalSupplies.Supplies
		local Options = {}
		for i=1, #supplies do
			if supplies[i].price then
				Options[#Options + 1] = {
					title = supplies[i].label..' - '..Strings.currency..''..addCommas(supplies[i].price),
					description = '',
					arrow = false,
					event = 'wasabi_ambulance:buyItem',
					args = { hospital = id, item = supplies[i].item, price = supplies[i].price }
				}
			else
				Options[#Options + 1] = {
					title = supplies[i].label,
					description = '',
					arrow = false,
					event = 'wasabi_ambulance:buyItem',
					args = { hospital = id, item = supplies[i].item }
				}
			end
		end
		if Config.MobileMenu.enabled then
			OpenMobileMenu('ems_supply_menu', Strings.request_supplies_target, Options)
		else
			lib.registerContext({
				id = 'ems_supply_menu',
				title = Strings.request_supplies_target,
				options = Options
			})
			lib.showContext('ems_supply_menu')
		end
	end
end

medicalWeaponsMenu = function(station)
	local data = Config.Locations[station].MedicalWeapons
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
			print('[wasabi_ambulance] : ARMORY NOT SET UP PROPERLY FOR GRADE: '..grade)
		else
			aData = data.weapons[grade]
		end
		local Options = {}
		for k,v in pairs(aData) do
			Options[#Options + 1] = {
				title = v.label,
				description = '',
				arrow = false,
				event = 'wasabi_ambulance:purchaseArmoury',
				args = { id = station, grade = grade, itemId = k, multiple = false }
			}
			if v.price then
				Options[#Options].description = Strings.currency..addCommas(v.price)
			end
			if v.multiple then
				Options[#Options].args.multiple = true
			end
		end
		lib.registerContext({
			id = 'trauma_armoury',
			title = Strings.request_weapons_target,
			options = Options
		})
		lib.showContext('trauma_armoury')
	else
		TriggerEvent('wasabi_ambulance:notify', Strings.no_permission, Strings.no_access_desc, 'error')
	end
end


openVehicleMenu = function(hosp)
	if HasGroup(Config.ambulanceJob) then
		inMenu = true
		local Options = {}
		for k,v in pairs(Config.Locations[hosp].Vehicles.Options) do
			if v.category == 'land' then
				table.insert(Options, {
					title = v.label,
					description = '',
					icon = 'car',
					arrow = true,
					event = 'wasabi_ambulance:spawnVehicle',
					args = { hospital = hosp, model = k }
				})
			elseif v.category == 'air' then
				table.insert(Options, {
					title = v.label,
					description = '',
					icon = 'helicopter',
					arrow = true,
					event = 'wasabi_ambulance:spawnVehicle',
					args = { hospital = hosp, model = k, category = v.category }
				})
			end
		end
		if Config.MobileMenu.enabled then
			OpenMobileMenu('ems_garage_menu', Strings.hospital_garage, Options)
		else
			lib.registerContext({
				id = 'ems_garage_menu',
				title = Strings.hospital_garage,
				onExit = function()
					inMenu = false
				end,
				options = Options
			})
			lib.showContext('ems_garage_menu')
		end
	end
end

function InteractWithMedbag(obj)
	if not DoesEntityExist(obj) then return end
	local Options = {
		{
			title = Strings.pickup_bag_target,
			arrow = false,
			event = 'wasabi_ambulance:pickupBag',
		},
		{
			title = Strings.interact_bag_target,
			arrow = false,
			event = 'wasabi_ambulance:interactBag',
		}
	}
	if Config.MobileMenu.enabled then
		OpenMobileMenu('interact_medbag_menu', Strings.medbag, Options)
	else
		lib.registerContext({
			id = 'interact_medbag_menu',
			title = Strings.medbag,
			options = Options
		})
		lib.showContext('interact_medbag_menu')
	end
end

function medBagPlaced(obj)
	if not DoesEntityExist(obj) then return end
	local coords = GetEntityCoords(obj)
	local targetPlaced = false
	local textUI = false
	CreateThread(function()
		while true do
			local sleep = 1500
			if DoesEntityExist(obj) then
				local plyCoords = GetEntityCoords(cache.ped)
				local dist = #(vector3(plyCoords.x, plyCoords.y, plyCoords.z) - vector3(coords.x, coords.y, coords.z))
				if dist <= 2.0 then
					if not textUI then
						ShowTextUI(Strings.interact_stretcher_ui)
						textUI = true
					end
					sleep = 0
					if IsControlJustPressed(0, 38) then
						InteractWithMedbag(obj)
					end
				else
					if textUI then
						HideTextUI()
						textUI = false
					end
				end
			else
				if textUI then
					HideTextUI()
					textUI = false
				end
				break
			end
			Wait(sleep)
		end
	end)
end

local medbagObj
useMedbag = function()
	local ped = cache.ped
	local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,2.0,0.55))
	lib.requestModel('xm_prop_x17_bag_med_01a', 100)
	medbagObj = CreateObjectNoOffset('xm_prop_x17_bag_med_01a', x, y, z, true, false)
	SetModelAsNoLongerNeeded('xm_prop_x17_bag_med_01a')
	SetCurrentPedWeapon(ped, `WEAPON_UNARMED`)
	AttachEntityToEntity(medbagObj, ped, GetPedBoneIndex(ped, 57005), 0.42, 0, -0.05, 0.10, 270.0, 60.0, true, true, false, true, 1, true)
	local bagEquipped = true
	local text_ui
	CreateThread(function()
		while bagEquipped do
			Wait()
			if not text_ui then
				ShowTextUI(Strings.drop_bag_ui)
				text_ui = true
			end
			if IsControlJustReleased(0, 38) then
				TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, 8.0, 1000, 50, 0, false, false, false)
				bagEquipped = nil
				text_ui = nil
				HideTextUI()
				Wait(1000)
				DetachEntity(medbagObj)
				PlaceObjectOnGroundProperly(medbagObj)
				if not Config.targetSystem then
					medBagPlaced(medbagObj)
				end
			end
		end
	end)
end

openDispatchMenu = function()
	if HasGroup(Config.ambulanceJob) then
		local Options = {
			{
				title = Strings.GoBack,
				description = '',
				icon = 'chevron-left',
				arrow = false,
				event = 'wasabi_ambulance:emsJobMenu',
			},
		}
		for k,v in pairs(plyRequests) do
			Options[#Options + 1] = {
				title = v,
				description = '',
				arrow = true,
				event = 'wasabi_ambulance:setRoute',
				args = {plyId = k}
			}
		end
		if #Options < 2 then
			Options[#Options + 1] = {
				title = Strings.no_requests,
				description = '',
				arrow = false,
				event = '',
			}
		end
		if Config.MobileMenu.enabled then
			OpenMobileMenu('ems_dispatch_menu', Strings.DispatchMenuTitle, Options)
		else
			lib.registerContext({
				id = 'ems_dispatch_menu',
				title = Strings.DispatchMenuTitle,
				options = Options
			})
			lib.showContext('ems_dispatch_menu')
		end
	end
end