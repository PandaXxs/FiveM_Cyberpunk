-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
ESX = exports[Config.ESXName]:getSharedObject()
plyRequests, deadPlayers, Injury = {}, {}, {}

TriggerEvent('esx_society:registerSociety', 'circlebar', 'circlebar', 'society_circlebar', 'society_circlebar', 'society_circlebar', {type = 'public'})

AddEventHandler('esx:playerDropped', function(playerId, reason)
    if plyRequests[playerId] then
        plyRequests[playerId] = nil
        TriggerClientEvent('wasabi_circlebar:syncRequests', -1, plyRequests, true)
    end
end)

RegisterServerEvent('wasabi_circlebar:restock')
AddEventHandler('wasabi_circlebar:restock', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    if xJob == 'circlebar' then
        if not data.price then
            xPlayer.addInventoryItem(data.item, 1)
        else
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_circlebar', function(account)
                if account.money >= data.price then
                    account.removeMoney(data.price)
                    xPlayer.addInventoryItem(data.item, 1)
                else
                    TriggerClientEvent('wasabi_circlebar:notify', source, Strings.not_enough_funds, Strings.not_enough_funds_desc, 'error')
                end
            end)
        end
    end
end)

ESX.RegisterServerCallback('wasabi_circlebar:itemCheck', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(item)
    cb(xItem.count)
end)

ESX.RegisterServerCallback('wasabi_circlebar:gItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    local authorized = false
    if xJob == 'circlebar' or authorized then
        xPlayer.addInventoryItem(item, 1)
        cb(true)
    else
        xPlayer.addInventoryItem('bandage', math.random(1,3))
        cb(false)
    end
end)

RegisterServerEvent('wasabi_circlebar:billPlayer')
AddEventHandler('wasabi_circlebar:billPlayer', function(target, amount)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        exports.pefcl:createInvoice(source, { to = xPlayer.getName(), toIdentifier = xPlayer.identifier, from = 'circlebar', fromIdentifier = nil, amount = amount, message = 'circlebar Bills', receiverAccountIdentifier = 'circlebar', expiresAt = nil })
    end
end)

RegisterServerEvent('wasabi_circlebar:announce')
AddEventHandler('wasabi_circlebar:announce', function(type, input)
    
    input = input or nil

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if type == 'open' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Circlebar', 'OUVERT', 'center-left', '#141517', '#909296', 'fas fa-cocktail', '#AAFCB5', 6000, -1)
        elseif type == 'close' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Circlebar', 'FERMER', 'center-left', '#141517', '#909296', 'fas fa-cocktail', '#FCAAAA', 6000, -1)
        elseif type == 'custom' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Circlebar', input, 'center-left', '#141517', '#909296', 'fas fa-cocktail', '#E2CDFF', 10000, -1)
        end
	end
end)
