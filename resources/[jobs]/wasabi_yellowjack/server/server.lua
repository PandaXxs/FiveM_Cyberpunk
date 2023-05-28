-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
ESX = exports[Config.ESXName]:getSharedObject()
plyRequests, deadPlayers, Injury = {}, {}, {}

TriggerEvent('esx_society:registerSociety', 'yellowpunk', 'yellowpunk', 'society_yellowpunk', 'society_yellowpunk', 'society_yellowpunk', {type = 'public'})

AddEventHandler('esx:playerDropped', function(playerId, reason)
    if plyRequests[playerId] then
        plyRequests[playerId] = nil
        TriggerClientEvent('wasabi_yellowpunk:syncRequests', -1, plyRequests, true)
    end
end)

RegisterServerEvent('wasabi_yellowpunk:restock')
AddEventHandler('wasabi_yellowpunk:restock', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    if xJob == 'yellowpunk' then
        if not data.price then
            xPlayer.addInventoryItem(data.item, 1)
        else
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_yellowpunk', function(account)
                if account.money >= data.price then
                    account.removeMoney(data.price)
                    xPlayer.addInventoryItem(data.item, 1)
                else
                    TriggerClientEvent('wasabi_yellowpunk:notify', source, Strings.not_enough_funds, Strings.not_enough_funds_desc, 'error')
                end
            end)
        end
    end
end)

ESX.RegisterServerCallback('wasabi_yellowpunk:itemCheck', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(item)
    cb(xItem.count)
end)

ESX.RegisterServerCallback('wasabi_yellowpunk:gItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    local authorized = false
    if xJob == 'yellowpunk' or authorized then
        xPlayer.addInventoryItem(item, 1)
        cb(true)
    else
        xPlayer.addInventoryItem('bandage', math.random(1,3))
        cb(false)
    end
end)

RegisterServerEvent('wasabi_yellowpunk:billPlayer')
AddEventHandler('wasabi_yellowpunk:billPlayer', function(target, amount)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        exports.pefcl:createInvoice(source, { to = xPlayer.getName(), toIdentifier = xPlayer.identifier, from = 'yellowpunk', fromIdentifier = nil, amount = amount, message = 'yellowpunk Bills', receiverAccountIdentifier = 'yellowpunk', expiresAt = nil })
    end
end)

RegisterServerEvent('wasabi_yellowpunk:announce')
AddEventHandler('wasabi_yellowpunk:announce', function(type, input)
    
    input = input or nil

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if type == 'open' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Yellowpunk', 'OUVERT', 'center-left', '#141517', '#909296', 'fas fa-beer', '#AAFCB5', 6000, -1)
        elseif type == 'close' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Yellowpunk', 'FERMER', 'center-left', '#141517', '#909296', 'fas fa-beer', '#FCAAAA', 6000, -1)
        elseif type == 'custom' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Yellowpunk', input, 'center-left', '#141517', '#909296', 'fas fa-beer', '#FFE5B0', 10000, -1)
        end
	end
end)
