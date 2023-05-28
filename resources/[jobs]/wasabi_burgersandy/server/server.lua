-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
ESX = exports[Config.ESXName]:getSharedObject()
plyRequests, deadPlayers, Injury = {}, {}, {}

TriggerEvent('esx_society:registerSociety', 'burgersandy', 'burgersandy', 'society_burgersandy', 'society_burgersandy', 'society_burgersandy', {type = 'public'})

AddEventHandler('esx:playerDropped', function(playerId, reason)
    if plyRequests[playerId] then
        plyRequests[playerId] = nil
    end
end)

RegisterServerEvent('wasabi_burgersandy:restock')
AddEventHandler('wasabi_burgersandy:restock', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    if xJob == 'burgersandy' then
        if not data.price then
            xPlayer.addInventoryItem(data.item, 1)
        else
            local xMoney = xPlayer.getMoney()
            if xMoney < data.price then
                TriggerClientEvent('wasabi_burgersandy:notify', source, Strings.not_enough_funds, Strings.not_enough_funds_desc, 'error')
            else
                xPlayer.removeAccountMoney('money', data.price)
                xPlayer.addInventoryItem(data.item, 1)
            end
        end
    end
end)

RegisterServerEvent('wasabi_burgersandy:giveitem')
AddEventHandler('wasabi_burgersandy:giveitem', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name

    local weight = xPlayer.getWeight() + xPlayer.getInventoryItem(item).weight

    if xJob == 'burgersandy' then
        if weight > xPlayer.maxWeight then
            TriggerClientEvent('wasabi_burgersandy:notify', source, 'Votre inventaire est plein !', '', 'error')
        else
            if item == 'menuBurgerSandy' then
                if xPlayer.getInventoryItem('painburger').count < 1 then
                    TriggerClientEvent('wasabi_burgersandy:notify', source, 'Vous n\'avez pas assez de pain burger !', '', 'error')
                    return
                elseif xPlayer.getInventoryItem('viande').count < 1 then
                    TriggerClientEvent('wasabi_burgersandy:notify', source, 'Vous n\'avez pas assez de viande !', '', 'error')
                    return
                end

                xPlayer.removeInventoryItem('painburger', 1)
                xPlayer.removeInventoryItem('viande', 1)
                xPlayer.addInventoryItem(item, 1)
            elseif item == 'menuBurgerSandyluxe' then
                if xPlayer.getInventoryItem('painburger').count < 1 then
                    TriggerClientEvent('wasabi_burgersandy:notify', source, 'Vous n\'avez pas assez de pain burger !', '', 'error')
                    return
                elseif xPlayer.getInventoryItem('viande').count < 1 then
                    TriggerClientEvent('wasabi_burgersandy:notify', source, 'Vous n\'avez pas assez de viande !', '', 'error')
                    return
                elseif xPlayer.getInventoryItem('frites').count < 1 then
                    TriggerClientEvent('wasabi_burgersandy:notify', source, 'Vous n\'avez pas assez de frites !', '', 'error')
                    return
                end
                xPlayer.removeInventoryItem('painburger', 1)
                xPlayer.removeInventoryItem('viande', 1)
                xPlayer.removeInventoryItem('frites', 1)
                xPlayer.addInventoryItem(item, 1)
            else
                xPlayer.addInventoryItem(item, 1)
            end
        end
    end
end)

RegisterServerEvent('wasabi_burgersandy:vente')
AddEventHandler('wasabi_burgersandy:vente', function(item, price)
    for i=1, #Config.SellItems do
        if HasItem(source, Config.SellItems[i].item) > 0 then
            local rewardAmount = 0
            for j=1, HasItem(source, Config.SellItems[i].item) do
                rewardAmount = rewardAmount + math.random(Config.SellItems[i].price[1], Config.SellItems[i].price[2])
            end
            if rewardAmount > 0 then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_burgersandy', function(account)
                    account.addMoney(rewardAmount)
                end)
                TriggerClientEvent('wasabi_fishing:notify', source, Strings.sold_for, (Strings.sold_for_desc):format(HasItem(source, Config.SellItems[i].item), Config.SellItems[i].label, addCommas(rewardAmount)), 'success')
                RemoveItem(source, Config.SellItems[i].item, HasItem(source, Config.SellItems[i].item))
            end
        end
    end
end)

ESX.RegisterServerCallback('wasabi_burgersandy:itemCheck', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(item)
    cb(xItem.count)
end)

ESX.RegisterServerCallback('wasabi_burgersandy:gItem', function(source, cb, item)
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
    if xJob == 'burgersandy' or authorized then
        xPlayer.addInventoryItem(item, 1)
        cb(true)
    else
        xPlayer.addInventoryItem('bandage', math.random(1,3))
        cb(false)
    end
end)

RegisterServerEvent('wasabi_burgersandy:billPlayer')
AddEventHandler('wasabi_burgersandy:billPlayer', function(target, amount)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        exports.pefcl:createInvoice(source, { to = xPlayer.getName(), toIdentifier = xPlayer.identifier, from = 'burgersandy', fromIdentifier = nil, amount = amount, message = 'burgersandy Bills', receiverAccountIdentifier = 'burgersandy', expiresAt = nil })
    end
end)

RegisterServerEvent('wasabi_burgersandy:announce')
AddEventHandler('wasabi_burgersandy:announce', function(type, input)
    
    input = input or nil

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if type == 'open' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Burgersandy', 'OUVERT', 'center-left', '#141517', '#909296', 'fas fa-hamburger', '#AAFCB5', 6000, -1)
        elseif type == 'close' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Burgersandy', 'FERMER', 'center-left', '#141517', '#909296', 'fas fa-hamburger', '#FCAAAA', 6000, -1)
        elseif type == 'custom' then
            TriggerEvent('projectrpUtils:sendAnnounce', 'Burgersandy', input, 'center-left', '#141517', '#909296', 'fas fa-hamburger', '#CD8D2B', 10000, -1)
        end
	end
end)

RegisterServerEvent('wasabi_burgersandy:RemoveItem')
AddEventHandler('wasabi_burgersandy:RemoveItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, count)
end)

RegisterNetEvent('wasabi_burgersandy:deletevehicle')
AddEventHandler('wasabi_burgersandy:deletevehicle', function()

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    local coordFrom = GetEntityCoords(GetPlayerPed(source))
    local vehicle = ESX.OneSync.GetClosestVehicle(coordFrom)

    local car = NetworkGetEntityFromNetworkId(vehicle)

    if DoesEntityExist(car) then
        DeleteEntity(car)
    end

end)

function HasItem(source, item)
    local player = GetPlayer(source)
    local item = player.getInventoryItem(item)
    if item ~= nil then
        return item.count
    else
        return 0
    end
end

function RemoveItem(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    player.removeInventoryItem(item, count, metadata, slot)
end

addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

function GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end