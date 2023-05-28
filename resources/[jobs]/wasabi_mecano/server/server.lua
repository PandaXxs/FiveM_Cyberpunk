-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
ESX = exports[Config.ESXName]:getSharedObject()
plyRequests, deadPlayers, Injury = {}, {}, {}

TriggerEvent('esx_society:registerSociety', 'mechanic', 'mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'public'})

AddEventHandler('esx:playerDropped', function(playerId, reason)
    if plyRequests[playerId] then
        plyRequests[playerId] = nil
        TriggerClientEvent('wasabi_mechanic:syncRequests', -1, plyRequests, true)
    end
end)

RegisterServerEvent('wasabi_mechanic:requestSync')
AddEventHandler('wasabi_mechanic:requestSync', function()
    TriggerClientEvent('wasabi_mechanic:syncRequests', source, plyRequests, true)
end)

RegisterServerEvent('wasabi_mechanic:removeObj')
AddEventHandler('wasabi_mechanic:removeObj', function(netObj)
    TriggerClientEvent('wasabi_mechanic:syncObj', -1, netObj)
end)

RegisterServerEvent('wasabi_mechanic:restock')
AddEventHandler('wasabi_mechanic:restock', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    if xJob == 'mechanic' then
        if not data.price then
            xPlayer.addInventoryItem(data.item, 1)
        else
            -- On vérifie si le joueur a assez d'argent sur son compte bancaire
            local xBank = xPlayer.getAccount('bank').money
            if xBank < data.price then
                TriggerClientEvent('wasabi_mechanic:notify', source, Strings.not_enough_funds, Strings.not_enough_funds_desc, 'error')
            else
                xPlayer.removeAccountMoney('bank', data.price)
                xPlayer.addInventoryItem(data.item, 1)
            end
        end
    end
end)

ESX.RegisterServerCallback('wasabi_mechanic:itemCheck', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(item)
    cb(xItem.count)
end)

ESX.RegisterServerCallback('wasabi_mechanic:gItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    local authorized = false
    if Config?.policeCanTreat?.enabled then
        for i=1, #Config.policeCanTreat.jobs do
            if xJob == Config.policeCanTreat.jobs[i] then
                authorized = true
                break
            end
        end
    end
    if xJob == 'mechanic' or authorized then
        xPlayer.addInventoryItem(item, 1)
        cb(true)
    else
        xPlayer.addInventoryItem('bandage', math.random(1,3))
        cb(false)
    end
end)

RegisterServerEvent('wasabi_mechanic:billPlayer')
AddEventHandler('wasabi_mechanic:billPlayer', function(target, amount)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        exports.pefcl:createInvoice(source, { to = xPlayer.getName(), toIdentifier = xPlayer.identifier, from = 'bennys', fromIdentifier = nil, amount = amount, message = 'Mechanic Bills', receiverAccountIdentifier = 'mechanic', expiresAt = nil })
    end
end)

RegisterServerEvent('wasabi_mechanic:announce')
AddEventHandler('wasabi_mechanic:announce', function(type, input)
    
    input = input or nil

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if type == 'open' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Mécanicien', 'OUVERT', 'center-left', '#141517', '#909296', 'fas fa-wrench', '#AAFCB5', 6000, -1)
        elseif type == 'close' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Mécanicien', 'FERMER', 'center-left', '#141517', '#909296', 'fas fa-wrench', '#FCAAAA', 6000, -1)
        elseif type == 'custom' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Mécanicien', input, 'center-left', '#141517', '#909296', 'fas fa-wrench', '#B0D8FF', 10000, -1)
        end
	end
end)

RegisterServerEvent('wasabi_mechanic:RemoveItem')
AddEventHandler('wasabi_mechanic:RemoveItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, count)
end)

RegisterServerEvent('wasabi_mechanic:onNPCJobMissionCompleted')
AddEventHandler('wasabi_mechanic:onNPCJobMissionCompleted', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local total   = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max);

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(total)
	end)

    TriggerClientEvent('wasabi_mechanic:notify', source, 'Votre société a gagné '.. total .. ' $', '', 'success')
end)

ESX.RegisterUsableItem(Config.BENNYSItems.toolbox, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(Config.BENNYSItems.toolbox, 1)
    TriggerClientEvent('wasabi_mechanic:usetoolbox', source)
end)

RegisterNetEvent('wasabi_mechanic:deletevehicle')
AddEventHandler('wasabi_mechanic:deletevehicle', function()

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    local coordFrom = GetEntityCoords(GetPlayerPed(source))
    local vehicle = ESX.OneSync.GetClosestVehicle(coordFrom)

    local car = NetworkGetEntityFromNetworkId(vehicle)

    if DoesEntityExist(car) then
        DeleteEntity(car)
    end

end)
