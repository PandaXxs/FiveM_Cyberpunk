-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
ESX = exports[Config.ESXName]:getSharedObject()
plyRequests, deadPlayers, Injury = {}, {}, {}

TriggerEvent('esx_society:registerSociety', 'taxi', 'taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

AddEventHandler('esx:playerDropped', function(playerId, reason)
    if plyRequests[playerId] then
        plyRequests[playerId] = nil
        TriggerClientEvent('wasabi_delamaintaxi:syncRequests', -1, plyRequests, true)
    end
end)

RegisterServerEvent('wasabi_delamaintaxi:requestSync')
AddEventHandler('wasabi_delamaintaxi:requestSync', function()
    TriggerClientEvent('wasabi_delamaintaxi:syncRequests', source, plyRequests, true)
end)

RegisterServerEvent('wasabi_delamaintaxi:removeObj')
AddEventHandler('wasabi_delamaintaxi:removeObj', function(netObj)
    TriggerClientEvent('wasabi_delamaintaxi:syncObj', -1, netObj)
end)

RegisterServerEvent('wasabi_delamaintaxi:restock')
AddEventHandler('wasabi_delamaintaxi:restock', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    if xJob == 'taxi' then
        if not data.price then
            xPlayer.addInventoryItem(data.item, 1)
        else
            local xMoney = xPlayer.getMoney()
            if xMoney < data.price then
                TriggerClientEvent('wasabi_delamaintaxi:notify', source, Strings.not_enough_funds, Strings.not_enough_funds_desc, 'error')
            else
                xPlayer.removeAccountMoney('money', data.price)
                xPlayer.addInventoryItem(data.item, 1)
            end
        end
    end
end)

ESX.RegisterServerCallback('wasabi_delamaintaxi:itemCheck', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(item)
    cb(xItem.count)
end)

ESX.RegisterServerCallback('wasabi_delamaintaxi:gItem', function(source, cb, item)
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
    if xJob == 'taxi' or authorized then
        xPlayer.addInventoryItem(item, 1)
        cb(true)
    else
        xPlayer.addInventoryItem('bandage', math.random(1,3))
        cb(false)
    end
end)

RegisterServerEvent('wasabi_delamaintaxi:billPlayer')
AddEventHandler('wasabi_delamaintaxi:billPlayer', function(target, amount)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        exports.pefcl:createInvoice(source, { to = xPlayer.getName(), toIdentifier = xPlayer.identifier, from = 'taxi', fromIdentifier = nil, amount = amount, message = 'taxi Bills', receiverAccountIdentifier = 'taxi', expiresAt = nil })
    end
end)

RegisterServerEvent('wasabi_delamaintaxi:announce')
AddEventHandler('wasabi_delamaintaxi:announce', function(type, input)
    
    input = input or nil  

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if type == 'open' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Delamain Taxi', 'OUVERT', 'center-left', '#141517', '#909296', 'fas fa-taxi', '#AAFCB5', 6000, -1)
        elseif type == 'close' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Delamain Taxi', 'FERMER', 'center-left', '#141517', '#909296', 'fas fa-taxi', '#FCAAAA', 6000, -1)
        elseif type == 'custom' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Delamain Taxi', input, 'center-left', '#141517', '#909296', 'fas fa-taxi', '#FFD101', 10000, -1)
        end
	end
end)

RegisterServerEvent('wasabi_delamaintaxi:RemoveItem')
AddEventHandler('wasabi_delamaintaxi:RemoveItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, count)
end)
