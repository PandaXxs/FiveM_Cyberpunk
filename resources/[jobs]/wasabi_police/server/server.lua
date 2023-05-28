-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
cuffedPlayers, GSRData = {}, {}

local addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

AddEventHandler('playerDropped', function (reason)
    if cuffedPlayers[source] then
        cuffedPlayers[source] = nil
    end
end)

RegisterServerEvent('wasabi_police:attemptTackle')
AddEventHandler('wasabi_police:attemptTackle', function(targetId)
    TriggerClientEvent('wasabi_police:tackled', targetId, source)
    TriggerClientEvent('wasabi_police:tackle', source)
end)

RegisterServerEvent('wasabi_police:escortPlayer')
AddEventHandler('wasabi_police:escortPlayer', function(targetId)
    if HasGroup(source, Config.policeJobs) then
        TriggerClientEvent('wasabi_police:setEscort', source, targetId)
        TriggerClientEvent('wasabi_police:escortedPlayer', targetId, source)
    end
end)

RegisterServerEvent('wasabi_police:inVehiclePlayer')
AddEventHandler('wasabi_police:inVehiclePlayer', function(targetId)
    if HasGroup(source, Config.policeJobs) then
        TriggerClientEvent('wasabi_police:stopEscorting', source)
        TriggerClientEvent('wasabi_police:putInVehicle', targetId)
    end
end)

RegisterServerEvent('wasabi_police:outVehiclePlayer')
AddEventHandler('wasabi_police:outVehiclePlayer', function(targetId)
    if HasGroup(source, Config.policeJobs) then
        TriggerClientEvent('wasabi_police:takeFromVehicle', targetId)
    end
end)

RegisterServerEvent('wasabi_police:setCuff')
AddEventHandler('wasabi_police:setCuff', function(isCuffed)
    cuffedPlayers[source] = isCuffed
    Player(source).state.cuffed = isCuffed
    if Framework == 'qb' then
        local player = GetPlayer(source)
        player.Functions.SetMetaData('ishandcuffed', isCuffed)
    end
end)

RegisterServerEvent('wasabi_police:setGSR')
AddEventHandler('wasabi_police:setGSR', function(positive)
    GSRData[source] = positive
end)

RegisterServerEvent('wasabi_police:svToggleDuty')
AddEventHandler('wasabi_police:svToggleDuty', function(job, grade)
    ToggleDuty(source, job, grade)
    TriggerClientEvent('wasabi_police:clToggleDuty', source, job)
end)

RegisterServerEvent('wasabi_police:qbBill')
AddEventHandler('wasabi_police:qbBill', function(target, amount, job)
    RemoveMoney(target, 'bank', amount)
    TriggerClientEvent('wasabi_police:notify', source, Strings.fine_sent, (Strings.fine_sent_desc):format(addCommas(amount)), 'success')
    TriggerClientEvent('wasabi_police:notify', target, Strings.fine_received, (Strings.fine_received_desc):format(addCommas(amount)), 'error')
    exports['qb-management']:AddMoney(job, amount)
end)

RegisterServerEvent('wasabi_police:handcuffPlayer')
AddEventHandler('wasabi_police:handcuffPlayer', function(target)
    if HasGroup(source, Config.policeJobs) then
        if cuffedPlayers[target] then
            TriggerClientEvent('wasabi_police:uncuffAnim', source, target)
            Wait(4000)
            TriggerClientEvent('wasabi_police:uncuff', target)
        else
            TriggerClientEvent('wasabi_police:arrested', target, source)
            TriggerClientEvent('wasabi_police:arrest', source)
        end
    end
end)

getPoliceOnline = function()
    local players = GetPlayers()
    local count = 0
    for i = 1, #players do
        local job, _grade = HasGroup(players[i], Config.policeJobs)
        if job then
            count = count + 1
        end
    end
    return count
end

exports('getPoliceOnline', getPoliceOnline)

lib.callback.register('wasabi_police:isCuffed', function(source, target)
    if cuffedPlayers[target] then
        return true
    else
        return false
    end
end)

lib.callback.register('wasabi_police:canPurchase', function(source, data)
    local itemData
    if data.grade > #Config.Locations[data.id].armoury.weapons then
        itemData = Config.Locations[data.id].armoury.weapons[#Config.Locations[data.id].armoury.weapons][data.itemId]
    elseif not Config.Locations[data.id].armoury.weapons[data.grade] then
        print('[wasabi_police] : Armory not set up properly for job grade: '..data.grade)
    else
        itemData = Config.Locations[data.id].armoury.weapons[data.grade][data.itemId]
    end
    if not itemData.price then
        if not Config.weaponsAsItems then
            if data.itemId:sub(0, 7) == 'WEAPON_' then
                AddWeapon(data.itemId, 200)
            else
                AddItem(source, data.itemId, data.quantity)
            end
        else
            AddItem(source, data.itemId, data.quantity)
        end
        return true
    else
        local xBank = GetPlayerAccountFunds(source, 'bank')
        if xBank < itemData.price then
            return false
        else
            RemoveMoney(source, 'bank', itemData.price)
            if not Config.weaponsAsItems then
                if data.itemId:sub(0, 7) == 'WEAPON_' then
                    AddWeapon(source, data.itemId, 200)
                else
                    AddItem(source, data.itemId, data.quantity)
                end
            else
                AddItem(source, data.itemId, data.quantity)
            end
            return true
        end
    end
end)

lib.callback.register('wasabi_police:gsrTest', function(source, target)
    if GSRData[target] then return true else return false end
end)