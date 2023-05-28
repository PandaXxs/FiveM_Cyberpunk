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

getClosestMechanic = function(coords)
	local closestMechanic
	local done
	for k,v in pairs(Config.Locations) do
		if not closestMechanic then
			closestMechanic = v.RespawnPoint
		else
			local oldDist = #(vector3(coords.x, coords.y, coords.z) - vector3(closestMechanic.coords.x, closestMechanic.coords.y, closestMechanic.coords.z))
			local newDist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.RespawnPoint.coords.x, v.RespawnPoint.coords.y, v.RespawnPoint.coords.z))
			if newDist < oldDist then
				closestMechanic = v.RespawnPoint
			end
		end
	end
	return closestMechanic
end

openOutfits = function(bennys)
	local data = Config.Locations[bennys].Cloakroom.Uniforms
	local Options = {
		{
			title = Strings.civilian_wear,
			description = '',
			arrow = false,
			event = 'wasabi_mechanic:changeClothes',
			args = 'civ_wear'
		}
	}
	for i=1, #data do
		table.insert(Options, {
			title = data[i].label,
			description = '',
			arrow = false,
			event = 'wasabi_mechanic:changeClothes',
			args = {male = data[i].male, female = data[i].female}
		})
	end
	lib.registerContext({
		id = 'meca_cloakroom',
		title = Strings.cloakroom,
		options = Options
	})
	lib.showContext('meca_cloakroom')
end

exports('openOutfits', openOutfits)

gItem = function(data)
	local item = data.item
	ESX.TriggerServerCallback('wasabi_mechanic:gItem', function(cb, item) 
		if cb then
			TriggerEvent('wasabi_mechanic:notify', Strings.successful, Strings.item_grab, 'success')
		else
			TriggerEvent('wasabi_mechanic:notify', Strings.successful, Strings.toolbox_pickup_civ, 'success')
		end
	end, item)
end

interactBag = function()
	if ESX.PlayerData.job.name == 'mechanic' or Authorized then
		local Options = {
			{
				title = Strings.toolbox_repairkit,
				description = Strings.toolbox_repairkit_desc,
				arrow = false,
				event = 'wasabi_mechanic:gItem',
				args = {item = Config.TreatmentItems.repairkit}
			},
			{
				title = Strings.toolbox_cleankit,
				description = Strings.toolbox_cleankit_desc,
				arrow = false,
				event = 'wasabi_mechanic:gItem',
				args = {item = Config.TreatmentItems.cleankit}
			},
			{
				title = Strings.toolbox_key,
				description = Strings.toolbox_key_desc,
				arrow = false,
				event = 'wasabi_mechanic:gItem',
				args = {item = Config.TreatmentItems.key}
			},
		}
		
		lib.registerContext({
			id = 'toolbox',
			title = Strings.toolbox,
			options = Options
		})
		lib.showContext('toolbox')
	else
		TriggerEvent('wasabi_mechanic:notify', Strings.not_mechanic, Strings.not_mechanic_desc, 'error')
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
	local bagHash = `prop_tool_box_04`
	local closestBag = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, bagHash, false)
	local bagCoords = GetEntityCoords(closestBag)
	TaskTurnPedToFaceCoord(ped, bagCoords.x, bagCoords.y, bagCoords.z, 2000)
	TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, 8.0, 1000, 50, 0, false, false, false)
	Wait(1000)
	TriggerServerEvent('wasabi_mechanic:removeObj', ObjToNet(closestBag))
	Wait(500)
	if not DoesEntityExist(closestBag) then
		ESX.TriggerServerCallback('wasabi_mechanic:gItem', function(cb) 
			if cb then
				TriggerEvent('wasabi_mechanic:notify', Strings.successful, Strings.toolbox_pickup, 'success')
			else
				TriggerEvent('wasabi_mechanic:notify', Strings.successful, Strings.toolbox_pickup_civ, 'success')
			end
		end, Config.BENNYSItems.toolbox)
	end
end

MechanicSuppliesMenu = function(id)
	if ESX.PlayerData.job.name == 'mechanic' then
		local supplies = Config.Locations[id].MechanicSupplies.Supplies
		local Options = {}
		for i=1, #supplies do
			if supplies[i].price then
				table.insert(Options, {
					title = supplies[i].label..' - '..Strings.currency..supplies[i].price,
					description = '',
					arrow = false,
					event = 'wasabi_mechanic:buyItem',
					args = { bennys = id, item = supplies[i].item, price = supplies[i].price }
				})
			else
				table.insert(Options, {
					title = supplies[i].label,
					description = '',
					arrow = false,
					event = 'wasabi_mechanic:buyItem',
					args = { bennys = id, item = supplies[i].item }
				})
			end
		end
		lib.registerContext({
			id = 'meca_supply_menu',
			title = Strings.request_supplies_target,
			options = Options
		})
		lib.showContext('meca_supply_menu')
	end
end

openVehicleMenu = function(hosp)
	if ESX.PlayerData.job.name == 'mechanic' then
		inMenu = true
		local Options = {}
		for k,v in pairs(Config.Locations[hosp].Vehicles.Options) do
			if v.category == 'land' then
				table.insert(Options, {
					title = v.label,
					description = '',
					icon = 'car',
					arrow = true,
					event = 'wasabi_mechanic:spawnVehicle',
					args = { bennys = hosp, model = k }
				})
			elseif v.category == 'air' then
				table.insert(Options, {
					title = v.label,
					description = '',
					icon = 'helicopter',
					arrow = true,
					event = 'wasabi_mechanic:spawnVehicle',
					args = { bennys = hosp, model = k, category = v.category }
				})
			end
		end
		lib.registerContext({
			id = 'meca_garage_menu',
			title = Strings.mechanic_garage,
			onExit = function()
				inMenu = false
			end,
			options = Options
		})
		lib.showContext('meca_garage_menu')
	end
end

function InteractWithtoolbox(obj)
	if not DoesEntityExist(obj) then return end
	local Options = {
		{
			title = Strings.pickup_bag_target,
			arrow = false,
			event = 'wasabi_mechanic:pickupBag',
		},
		{
			title = Strings.interact_bag_target,
			arrow = false,
			event = 'wasabi_mechanic:interactBag',
		}
	}
	lib.registerContext({
		id = 'interact_toolbox_menu',
		title = Strings.toolbox,
		options = Options
	})
	lib.showContext('interact_toolbox_menu')
end

function toolboxPlaced(obj)
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
						lib.showTextUI(Strings.interact_stretcher_ui)
						textUI = true
					end
					sleep = 0
					if IsControlJustPressed(0, 38) then
						InteractWithtoolbox(obj)
					end
				else
					if textUI then
						lib.hideTextUI()
						textUI = false
					end
				end
			else
				if textUI then
					lib.hideTextUI()
					textUI = false
				end
				break
			end
			Wait(sleep)
		end
	end)
end

local toolboxObj
usetoolbox = function()
	local ped = cache.ped
	local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,2.0,0.55))
	lib.requestModel('prop_tool_box_04', 100)
	toolboxObj = CreateObjectNoOffset('prop_tool_box_04', x, y, z, true, false)
	SetModelAsNoLongerNeeded('prop_tool_box_04')
	SetCurrentPedWeapon(ped, `WEAPON_UNARMED`)
	AttachEntityToEntity(toolboxObj, ped, GetPedBoneIndex(ped, 57005), 0.42, 0, -0.05, 0.10, 270.0, 60.0, true, true, false, true, 1, true)
	local bagEquipped = true
	local text_ui
	CreateThread(function()
		while bagEquipped do
			Wait()
			if not text_ui then
				lib.showTextUI(Strings.drop_bag_ui)
				text_ui = true
			end
			if IsControlJustReleased(0, 38) then
				TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, 8.0, 1000, 50, 0, false, false, false)
				bagEquipped = nil
				text_ui = nil
				lib.hideTextUI()
				Wait(1000)
				DetachEntity(toolboxObj)
				PlaceObjectOnGroundProperly(toolboxObj)
				if not Config.targetSystem then
					toolboxPlaced(toolboxObj)
				end
			end
		end
	end)
end

openJobMenu = function()
	if ESX.PlayerData.job.name == 'mechanic' then
		local Options = {
			{
				title = Strings.announce,
				description = Strings.announce_desc,
				icon = 'fas fa-bullhorn',
				arrow = true,
				event = 'wasabi_mechanic:announceMenu',
			},
		}
		
		if Config.billingSystem then
			table.insert(Options, {
				title = Strings.bill_customer,
				description = Strings.bill_customer_desc,
				icon = 'file-invoice',
				arrow = false,
				event = 'wasabi_mechanic:billCustomer',
			})
		end
		-- table.insert(Options, {
		-- 	title = 'Commencer une mission',
		-- 	description = '',
		-- 	icon = 'fas fa-bullhorn',
		-- 	arrow = false,
		-- 	event = 'wasabi_mechanic:Mission',
		-- 	args = {
		-- 		mission = true
		-- 	}
		-- })
	
		-- 	table.insert(Options, {
		-- 	title = 'Annuler la mission',
		-- 	description = '',
		-- 	icon = 'fas fa-bullhorn',
		-- 	arrow = false,
		-- 	event = 'wasabi_mechanic:Mission',
		-- 	args = {
		-- 		mission = false
		-- 	}
		-- })
		lib.registerContext({
			id = 'meca_job_menu',
			title = Strings.JobMenuTitle,
			options = Options
		})
		lib.showContext('meca_job_menu')
	end
end

openAnnounceMenu = function()
	if ESX.PlayerData.job.name == 'mechanic' then
		local Options = {
			{
				title = Strings.GoBack,
				description = '',
				icon = 'chevron-left',
				arrow = false,
				event = 'wasabi_mechanic:mecaJobMenu',
			},
			{
				title = Strings.announce..': '..Strings.announce_open,
				description = Strings.announce_desc,
				icon = 'fas fa-check',
				arrow = false,
				event = 'wasabi_mechanic:announce',
				args = {type = 'open'}
			},
			{
				title = Strings.announce..': '..Strings.announce_close,
				description = Strings.announce_desc,
				icon = 'fas fa-times',
				arrow = false,
				event = 'wasabi_mechanic:announce',
				args = {type = 'close'}
			},
			{
				title = Strings.announce..': '..Strings.announce_custom,
				description = Strings.announce_desc,
				icon = 'fas fa-pencil',
				arrow = false,
				event = 'wasabi_mechanic:announce',
				args = {type = 'custom'}
			},
		}
		if #Options < 2 then
			table.insert(Options, {
				title = Strings.no_requests,
				description = '',
				arrow = false,
				event = '',
			})
		end
		lib.registerContext({
			id = 'mechanic_announce_menu',
			title = Strings.AnnounceMenuTitle,
			options = Options
		})
		lib.showContext('mechanic_announce_menu')
	end
end
