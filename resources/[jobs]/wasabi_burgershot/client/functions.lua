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

getClosestBurgershot = function(coords)
	local closestBurgershot
	local done
	for k,v in pairs(Config.Locations) do
		if not closestBurgershot then
			closestBurgershot = v.RespawnPoint
		else
			local oldDist = #(vector3(coords.x, coords.y, coords.z) - vector3(closestBurgershot.coords.x, closestBurgershot.coords.y, closestBurgershot.coords.z))
			local newDist = #(vector3(coords.x, coords.y, coords.z) - vector3(v.RespawnPoint.coords.x, v.RespawnPoint.coords.y, v.RespawnPoint.coords.z))
			if newDist < oldDist then
				closestBurgershot = v.RespawnPoint
			end
		end
	end
	return closestBurgershot
end

openOutfits = function(burgershot)
	local data = Config.Locations[burgershot].Cloakroom.Uniforms
	local Options = {
		{
			title = Strings.civilian_wear,
			description = '',
			arrow = false,
			event = 'wasabi_burgershot:changeClothes',
			args = 'civ_wear'
		}
	}
	for i=1, #data do
		table.insert(Options, {
			title = data[i].label,
			description = '',
			arrow = false,
			event = 'wasabi_burgershot:changeClothes',
			args = {male = data[i].male, female = data[i].female}
		})
	end
	lib.registerContext({
		id = 'burger_cloakroom',
		title = Strings.cloakroom,
		options = Options
	})
	lib.showContext('burger_cloakroom')
end

exports('openOutfits', openOutfits)

gItem = function(data)
	local item = data.item
	ESX.TriggerServerCallback('wasabi_burgershot:gItem', function(cb, item) 
		if cb then
			TriggerEvent('wasabi_burgershot:notify', Strings.successful, Strings.item_grab, 'success')
		else
			TriggerEvent('wasabi_burgershot:notify', Strings.successful, Strings.toolbox_pickup_civ, 'success')
		end
	end, item)
end

BurgershotSuppliesMenu = function(id)
	if ESX.PlayerData.job.name == 'burgershot' then
		local supplies = Config.Locations[id].BurgershotSupplies.Supplies
		local Options = {}
		for i=1, #supplies do
			if supplies[i].price then
				table.insert(Options, {
					title = supplies[i].label..' - '..Strings.currency..supplies[i].price,
					description = '',
					arrow = false,
					event = 'wasabi_burgershot:buyItem',
					args = { burgershot = id, item = supplies[i].item, price = supplies[i].price }
				})
			else
				table.insert(Options, {
					title = supplies[i].label,
					description = '',
					arrow = false,
					event = 'wasabi_burgershot:buyItem',
					args = { burgershot = id, item = supplies[i].item }
				})
			end
		end
		lib.registerContext({
			id = 'burger_supply_menu',
			title = Strings.request_supplies_target,
			options = Options
		})
		lib.showContext('burger_supply_menu')
	end
end

openVehicleMenu = function(hosp)
	if ESX.PlayerData.job.name == 'burgershot' then
		inMenu = true
		local Options = {}
		for k,v in pairs(Config.Locations[hosp].Vehicles.Options) do
			if v.category == 'land' then
				table.insert(Options, {
					title = v.label,
					description = '',
					icon = 'car',
					arrow = true,
					event = 'wasabi_burgershot:spawnVehicle',
					args = { burgershot = hosp, model = k }
				})
			elseif v.category == 'air' then
				table.insert(Options, {
					title = v.label,
					description = '',
					icon = 'helicopter',
					arrow = true,
					event = 'wasabi_burgershot:spawnVehicle',
					args = { burgershot = hosp, model = k, category = v.category }
				})
			end
		end
		lib.registerContext({
			id = 'burger_garage_menu',
			title = Strings.burgershot_garage,
			onExit = function()
				inMenu = false
			end,
			options = Options
		})
		lib.showContext('burger_garage_menu')
	end
end

openJobMenu = function()
	if ESX.PlayerData.job.name == 'burgershot' then
		local Options = {
			{
				title = Strings.announce,
				description = Strings.announce_desc,
				icon = 'fas fa-bullhorn',
				arrow = true,
				event = 'wasabi_burgershot:announceMenu',
			},
		}
		
		if Config.billingSystem then
			table.insert(Options, {
				title = Strings.bill_customer,
				description = Strings.bill_customer_desc,
				icon = 'file-invoice',
				arrow = false,
				event = 'wasabi_burgershot:billCustomer',
			})
		end
		lib.registerContext({
			id = 'burger_job_menu',
			title = Strings.JobMenuTitle,
			options = Options
		})
		lib.showContext('burger_job_menu')
	end
end

openAnnounceMenu = function()
	if ESX.PlayerData.job.name == 'burgershot' then
		local Options = {
			{
				title = Strings.GoBack,
				description = '',
				icon = 'chevron-left',
				arrow = false,
				event = 'wasabi_burgershot:burgerJobMenu',
			},
			{
				title = Strings.announce..': '..Strings.announce_open,
				description = Strings.announce_desc,
				icon = 'fas fa-check',
				arrow = false,
				event = 'wasabi_burgershot:announce',
				args = {type = 'open'}
			},
			{
				title = Strings.announce..': '..Strings.announce_close,
				description = Strings.announce_desc,
				icon = 'fas fa-times',
				arrow = false,
				event = 'wasabi_burgershot:announce',
				args = {type = 'close'}
			},
			{
				title = Strings.announce..': '..Strings.announce_custom,
				description = Strings.announce_desc,
				icon = 'fas fa-pencil',
				arrow = false,
				event = 'wasabi_burgershot:announce',
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
			id = 'burgershot_announce_menu',
			title = Strings.AnnounceMenuTitle,
			options = Options
		})
		lib.showContext('burgershot_announce_menu')
	end
end

openRecolteViande = function()
	TriggerEvent('wasabi_burgershot:notify', 'Récolte en cours...', '', 'success')
	if lib.progressCircle({
		duration = 7500,
		position = 'bottom',
		label = 'Récolte de la viande en cours...',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			scenario = 'PROP_HUMAN_PARKING_METER',
		},
	}) then
		TriggerServerEvent('wasabi_burgershot:giveitem', 'viande')
	end
end

openRecoltePain = function()
	TriggerEvent('wasabi_burgershot:notify', 'Récolte en cours...', '', 'success')
	if lib.progressCircle({
		duration = 7500,
		position = 'bottom',
		label = 'Récolte du pain en cours...',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			scenario = 'PROP_HUMAN_PARKING_METER',
		},
	}) then
		TriggerServerEvent('wasabi_burgershot:giveitem', 'painburger')
	end
end

openRecolteFrites = function()
	TriggerEvent('wasabi_burgershot:notify', 'Récolte en cours...', '', 'success')
	if lib.progressCircle({
		duration = 7500,
		position = 'bottom',
		label = 'Récolte de la viande en cours...',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			scenario = 'PROP_HUMAN_PARKING_METER',
		},
	}) then
		TriggerServerEvent('wasabi_burgershot:giveitem', 'frites')
	end
end

openFabMenu = function()
	if ESX.PlayerData.job.name == 'burgershot' then
		local Options = {
			{
				title = 'Menu Whiteburger',
				description = Strings.fab_desc,
				icon = 'fas fa-hamburger',
				arrow = false,
				event = 'wasabi_burgershot:menu',
				args = {menu = 'menuburgershot'}
			},
			{
				title = 'Menu Prestige',
				description = Strings.fab_desc,
				icon = 'fas fa-hamburger',
				arrow = false,
				event = 'wasabi_burgershot:menu',
				args = {menu = 'menuburgershotluxe'}
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
			id = 'burgershot_fab_menu',
			title = 'Menu de fabrication',
			options = Options
		})
		lib.showContext('burgershot_fab_menu')
	end
end

openBoissonMenu = function()
	if ESX.PlayerData.job.name == 'burgershot' then
		local Options = {
			{
				title = 'Soda',
				description = Strings.fab_desc,
				icon = 'fa-solid fa-glass-water',
				arrow = false,
				event = 'wasabi_burgershot:boisson',
				args = {item = 'sodaburgershot'}
			},
		}
		lib.registerContext({
			id = 'burgershot_boisson_menu',
			title = 'Menu boisson',
			options = Options
		})
		lib.showContext('burgershot_boisson_menu')
	end
end

openDessertMenu = function()
	if ESX.PlayerData.job.name == 'burgershot' then
		local Options = {
			{
				title = 'Donuts',
				description = Strings.fab_desc,
				icon = 'fa-solid fa-cookie-bite',
				arrow = false,
				event = 'wasabi_burgershot:dessert',
				args = {item = 'donuts'}
			},
		}
		lib.registerContext({
			id = 'burgershot_dessert_menu',
			title = 'Menu dessert',
			options = Options
		})
		lib.showContext('burgershot_dessert_menu')
	end
end

openVente = function()
	TriggerServerEvent('wasabi_burgershot:vente')
end