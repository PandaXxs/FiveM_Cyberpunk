if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports['es_extended']:getSharedObject()
Framework, PlayerLoaded, PlayerData = 'esx', nil, {}

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    PlayerLoaded = true
	AddF5ComponentRadialItems()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName or not ESX.PlayerLoaded then return end
    PlayerData = ESX.GetPlayerData()
    PlayerLoaded = true

	-- Add radial menu items
    AddF5ComponentRadialItems()
end)

-- Main thread
Citizen.CreateThread(function()
	AddF5ComponentRadialItems()
	print('AddF5ComponentRadialItems')
end)

-- radial
lib.registerRadial({
	id = 'personal_menu',
	items = {
		{
			label = 'Intéraction avec un citoyen',
			icon = 'user',
			menu = 'personal_menu_citoyen'
		},
		{
			label = 'Intéraction avec un véhicule',
			icon = 'car',
			menu = 'personal_menu_vehicle'
		},
	}
})

lib.registerRadial({ -- Police vehicle menu
	id = 'personal_menu_citoyen',
	items = {
		{
			label = 'Handcuff',
			icon = 'handcuffs',
			onSelect = function()
				TriggerEvent('wasabi_police:handcuffPlayer')
			end
		},
		{
			label = 'Escort',
			icon = 'people-pulling',
			onSelect = function()
				TriggerEvent('wasabi_police:escortPlayer')
			end
		},
		{
			label = 'Search',
			icon = 'search',
			onSelect = function()
				TriggerEvent('wasabi_police:searchPlayer')
			end
		},
		{
			label = 'Check ID',
			icon = 'id-card',
			onSelect = function()
				TriggerEvent('wasabi_police:checkId')
			end
		},
		{
			label = 'Vehicle',
			icon = 'car',
			menu = 'police_menu_vehicle'
		},
	}
})

lib.registerRadial({ -- Police vehicle menu
	id = 'personal_menu_vehicle',
	items = {
		{
			label = 'Info',
			icon = 'circle-info',
			onSelect = function()
				TriggerEvent('wasabi_police:vehicleInfo')
			end
		},
		{
			label = 'Lockpick',
			icon = 'key',
			onSelect = function()
				TriggerEvent('wasabi_police:lockpickVehicle')
			end
		},
		{
			label = 'Impound',
			icon = 'trailer',
			onSelect = function()
				TriggerEvent('wasabi_police:impoundVehicle')
			end
		},
		{
			label = 'Seat',
			icon = 'door-closed',
			onSelect = function()
				TriggerEvent('wasabi_police:inVehiclePlayer')
			end
		},
		{
			label = 'Unseat',
			icon = 'door-open',
			onSelect = function()
				TriggerEvent('wasabi_police:outVehiclePlayer')
			end
		},
	}
})
