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

getClosestunipunk = function(coords)
	local closestunipunk
	local done
	for k,v in pairs(Config.Locations) do
		if not closestunipunk then
			closestunipunk = v.RespawnPoint
		else
			local oldDist = #(vector3(coords.x, coords.y, coords.z) - vector3(closestunipunk.coords.x, closestunipunk.coords.y, closestunipunk.coords.z))
			local newDist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.RespawnPoint.coords.x, v.RespawnPoint.coords.y, v.RespawnPoint.coords.z))
			if newDist < oldDist then
				closestunipunk = v.RespawnPoint
			end
		end
	end
	return closestunipunk
end

openOutfits = function(unipunk)
	local data = Config.Locations[unipunk].Cloakroom.Uniforms
	local Options = {
		{
			title = Strings.civilian_wear,
			description = '',
			arrow = false,
			event = 'wasabi_unipunk:changeClothes',
			args = 'civ_wear'
		}
	}
	for i=1, #data do
		table.insert(Options, {
			title = data[i].label,
			description = '',
			arrow = false,
			event = 'wasabi_unipunk:changeClothes',
			args = {male = data[i].male, female = data[i].female}
		})
	end
	lib.registerContext({
		id = 'unipunk_cloakroom',
		title = Strings.cloakroom,
		options = Options
	})
	lib.showContext('unipunk_cloakroom')
end

exports('openOutfits', openOutfits)

gItem = function(data)
	local item = data.item
	ESX.TriggerServerCallback('wasabi_unipunk:gItem', function(cb, item) 
		if cb then
			TriggerEvent('wasabi_unipunk:notify', Strings.successful, Strings.item_grab, 'success')
		else
			TriggerEvent('wasabi_unipunk:notify', Strings.successful, Strings.toolbox_pickup_civ, 'success')
		end
	end, item)
end

interactBag = function()
	if ESX.PlayerData.job.name == 'unipunk' or Authorized then
		local Options = {
			{
				title = Strings.toolbox_repairkit,
				description = Strings.toolbox_repairkit_desc,
				arrow = false,
				event = 'wasabi_unipunk:gItem',
				args = {item = Config.TreatmentItems.repairkit}
			},
			{
				title = Strings.toolbox_cleankit,
				description = Strings.toolbox_cleankit_desc,
				arrow = false,
				event = 'wasabi_unipunk:gItem',
				args = {item = Config.TreatmentItems.cleankit}
			},
		}
		
		lib.registerContext({
			id = 'toolbox',
			title = Strings.toolbox,
			options = Options
		})
		lib.showContext('toolbox')
	else
		TriggerEvent('wasabi_unipunk:notify', Strings.not_unipunk, Strings.not_unipunk_desc, 'error')
	end
end

deleteObj = function(bag)
	if DoesEntityExist(bag) then
		SetEntityAsMissionEntity(bag, true, true)
		DeleteObject(bag)
		DeleteEntity(bag)
	end
end

unipunkSuppliesMenu = function(id)
	if ESX.PlayerData.job.name == 'unipunk' then
		local supplies = Config.Locations[id].unipunkSupplies.Supplies
		local Options = {}
		for i=1, #supplies do
			if supplies[i].price then
				table.insert(Options, {
					title = supplies[i].label..' - '..Strings.currency..supplies[i].price,
					description = '',
					arrow = false,
					event = 'wasabi_unipunk:buyItem',
					args = { unipunk = id, item = supplies[i].item, price = supplies[i].price }
				})
			else
				table.insert(Options, {
					title = supplies[i].label,
					description = '',
					arrow = false,
					event = 'wasabi_unipunk:buyItem',
					args = { unipunk = id, item = supplies[i].item }
				})
			end
		end
		lib.registerContext({
			id = 'unipunk_supply_menu',
			title = Strings.request_supplies_target,
			options = Options
		})
		lib.showContext('unipunk_supply_menu')
	end
end

openVehicleMenu = function(hosp)
	if ESX.PlayerData.job.name == 'unipunk' then
		inMenu = true
		local Options = {}
		for k,v in pairs(Config.Locations[hosp].Vehicles.Options) do
			if v.category == 'land' then
				table.insert(Options, {
					title = v.label,
					description = '',
					icon = 'car',
					arrow = true,
					event = 'wasabi_unipunk:spawnVehicle',
					args = { unipunk = hosp, model = k }
				})
			elseif v.category == 'air' then
				table.insert(Options, {
					title = v.label,
					description = '',
					icon = 'helicopter',
					arrow = true,
					event = 'wasabi_unipunk:spawnVehicle',
					args = { unipunk = hosp, model = k, category = v.category }
				})
			end
		end
		lib.registerContext({
			id = 'unipunk_garage_menu',
			title = Strings.unipunk_garage,
			onExit = function()
				inMenu = false
			end,
			options = Options
		})
		lib.showContext('unipunk_garage_menu')
	end
end

openJobMenu = function()
	if ESX.PlayerData.job.name == 'unipunk' then
		local Options = {
			{
				title = Strings.announce,
				description = Strings.announce_desc,
				icon = 'fas fa-bullhorn',
				arrow = true,
				event = 'wasabi_unipunk:announceMenu',
			},
		}
		if Config.billingSystem then
			table.insert(Options, {
				title = Strings.bill_customer,
				description = Strings.bill_customer_desc,
				icon = 'file-invoice',
				arrow = false,
				event = 'wasabi_unipunk:billCustomer',
			})
		end
		lib.registerContext({
			id = 'unipunk_job_menu',
			title = Strings.JobMenuTitle,
			options = Options
		})
		lib.showContext('unipunk_job_menu')
	end
end

openAnnounceMenu = function()
	if ESX.PlayerData.job.name == 'unipunk' then
		local Options = {
			{
				title = Strings.GoBack,
				description = '',
				icon = 'chevron-left',
				arrow = false,
				event = 'wasabi_unipunk:unipunkJobMenu',
			},
			{
				title = Strings.announce..': '..Strings.announce_open,
				description = Strings.announce_desc,
				icon = 'fas fa-check',
				arrow = false,
				event = 'wasabi_unipunk:announce',
				args = {type = 'open'}
			},
			{
				title = Strings.announce..': '..Strings.announce_close,
				description = Strings.announce_desc,
				icon = 'fas fa-times',
				arrow = false,
				event = 'wasabi_unipunk:announce',
				args = {type = 'close'}
			},
			{
				title = Strings.announce..': '..Strings.announce_custom,
				description = Strings.announce_desc,
				icon = 'fas fa-pencil',
				arrow = false,
				event = 'wasabi_unipunk:announce',
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
			id = 'unipunk_announce_menu',
			title = Strings.AnnounceMenuTitle,
			options = Options
		})
		lib.showContext('unipunk_announce_menu')
	end
end
