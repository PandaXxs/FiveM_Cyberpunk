-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
plyRequests, deadPlayers, Injury = {}, {}, {}

if Framework == 'esx' then
    TriggerEvent('esx_society:registerSociety', Config.ambulanceJob, Config.ambulanceJob, 'society_'..Config.ambulanceJob, 'society_'..Config.ambulanceJob, 'society_'..Config.ambulanceJob, {type = 'public'})
end

AddEventHandler('playerDropped', function (reason)
    local playerId = source
    if deadPlayers[playerId] then deadPlayers[playerId] = nil end
    if Injury[playerId] then Injury[playerId] = nil end
    if plyRequests[playerId] then 
        plyRequests[playerId] = nil
        TriggerClientEvent('wasabi_ambulance:syncRequests', -1, plyRequests, true)
    end
end)

sqlSetStatus = function(id, isDead)
    if Framework == 'qb' then return end
    local xPlayer = ESX.GetPlayerFromId(id)
    if isDead then
        isDead = 1
    else
        isDead = 0
    end
    MySQL.Async.execute('UPDATE users SET is_dead = @is_dead WHERE identifier = @identifier', {
		['@is_dead'] = isDead,
		['@identifier'] = xPlayer.identifier
	})
end

RegisterServerEvent('wasabi_ambulance:setDeathStatus')
AddEventHandler('wasabi_ambulance:setDeathStatus', function(isDead)
	deadPlayers[source] = isDead
    Player(source).state.dead = isDead
    if not isDead then
        Injury[source] = nil
        if plyRequests[source] then
            plyRequests[source] = nil
            TriggerClientEvent('wasabi_ambulance:syncRequests', -1, plyRequests, true)
        end
    end
    if Config.AntiCombatLog.enabled and Framework == 'esx' then
        sqlSetStatus(source, isDead)
    end
    if Framework == 'qb' then
        local Player = GetPlayer(source)
        Player.Functions.SetMetaData("isdead", isDead)
    end
    if Config.MuteDeadPlayers then
        MumbleSetPlayerMuted(source, isDead)
    end
end)

RegisterServerEvent('wasabi_ambulance:injurySync')
AddEventHandler('wasabi_ambulance:injurySync', function(injury)
    Injury[source] = injury
end)

RegisterServerEvent('wasabi_ambulance:onPlayerDistress')
AddEventHandler('wasabi_ambulance:onPlayerDistress', function()
    local name = GetName(source)
    plyRequests[source] = name
    TriggerClientEvent('wasabi_ambulance:syncRequests', -1, plyRequests, false)
end)

RegisterServerEvent('wasabi_ambulance:requestSync')
AddEventHandler('wasabi_ambulance:requestSync', function()
    TriggerClientEvent('wasabi_ambulance:syncRequests', source, plyRequests, true)
end)

RegisterServerEvent('wasabi_ambulance:revivePlayer')
AddEventHandler('wasabi_ambulance:revivePlayer', function(targetId)
    if HasItem(source, Config.EMSItems.revive.item) > 0 then
        if Config.EMSItems.revive.remove then
            RemoveItem(source, Config.EMSItems.revive.item, 1)
        end
        if Config.ReviveRewards.enabled then
            local reward = 0
            if not Injury[targetId] then
                reward = Config.ReviveRewards.no_injury
            else
                reward = Config.ReviveRewards[Injury[targetId]]
            end
            if reward > 0 then
                AddMoney(source, Config.ReviveRewards.paymentAcoount, reward)
                TriggerClientEvent('wasabi_ambulance:notify', source, Strings.player_successful_revive, (Strings.player_successful_revive_reward_desc):format(reward), 'success')
            else
                TriggerClientEvent('wasabi_ambulance:notify', source, Strings.player_successful_revive, Strings.player_successful_revive_desc, 'success')
            end
        else
            TriggerClientEvent('wasabi_ambulance:notify', source, Strings.player_successful_revive, Strings.player_successful_revive_desc, 'success')
        end
        TriggerClientEvent('wasabi_ambulance:revivePlayer', targetId)
    end
end)

RegisterServerEvent('wasabi_ambulance:healPlayer')
AddEventHandler('wasabi_ambulance:healPlayer', function(targetId)
    local authorized = false
    if Config?.policeCanTreat?.enabled and HasGroup(source, Config.policeCanTreat.jobs) then
        authorized = true
    end
    if targetId == source then
        if HasItem(source, Config.EMSItems.heal.item) > 0 then
            RemoveItem(source, Config.EMSItems.heal.item, 1)
            TriggerClientEvent('wasabi_ambulance:heal', source, false, true)
            TriggerClientEvent('wasabi_ambulance:notify', source, Strings.used_meditkit, Strings.used_medikit_desc, 'success')
        end
    elseif HasGroup(source, Config.ambulanceJob) or authorized then
        if HasItem(source, Config.EMSItems.heal.item) > 0 then
            if Config.EMSItems.heal.remove then
                RemoveItem(source, Config.EMSItems.heal.item, 1)
            end
            TriggerClientEvent('wasabi_ambulance:notify', source, Strings.player_successful_heal, Strings.player_successful_heal_desc, 'success')
            TriggerClientEvent('wasabi_ambulance:heal', targetId, true, false)
        end
    end
end)

RegisterServerEvent('wasabi_ambulance:treatPlayer')
AddEventHandler('wasabi_ambulance:treatPlayer', function(target, injury)
    if target > 0 then
        local authorized = false
        if Config?.policeCanTreat?.enabled and HasGroup(source, Config.policeCanTreat.jobs) then
            authorized = true
        end
        if HasGroup(source, Config.ambulanceJob) or authorized then
            if HasItem(source, Config.TreatmentItems[injury]) > 0 then
                RemoveItem(source, Config.TreatmentItems[injury], 1)
                Injury[target] = nil
                TriggerClientEvent('wasabi_ambulance:notify', source, Strings.player_treated, Strings.player_treated_desc, 'success')
            end
        end
    end
end)

RegisterServerEvent('wasabi_ambulance:sedatePlayer')
AddEventHandler('wasabi_ambulance:sedatePlayer', function(target)
    if target > 0 then
        local authorized = false
        if Config?.policeCanTreat?.enabled then
            if HasGroup(source, Config.policeCanTreat.jobs) then
                authorized = true
            end
        end
        if HasGroup(source, Config.ambulanceJob) or authorized then
            if HasItem(source, Config.EMSItems.sedate.item) > 0 then
                if Config.EMSItems.sedate.remove then
                    RemoveItem(source, Config.EMSItems.sedate.item, 1)
                end
                TriggerClientEvent('wasabi_ambulance:notify', target, Strings.target_sedated, Strings.target_sedated_desc, 'inform')
                TriggerClientEvent('wasabi_ambulance:notify', source, Strings.target_sedated, Strings.player_successful_sedate_desc, 'success')
                TriggerClientEvent('wasabi_ambulance:sedate', target)
            end
        end
    end
end)

RegisterServerEvent('wasabi_ambulance:removeObj')
AddEventHandler('wasabi_ambulance:removeObj', function(netObj)
    TriggerClientEvent('wasabi_ambulance:syncObj', -1, netObj)
end)

RegisterServerEvent('wasabi_ambulance:placeOnStretcher')
AddEventHandler('wasabi_ambulance:placeOnStretcher', function(target)
    TriggerClientEvent('wasabi_ambulance:placeOnStretcher', target)
end)

RegisterServerEvent('wasabi_ambulance:putInVehicle')
AddEventHandler('wasabi_ambulance:putInVehicle', function(target)
    if target > 0 then
        local authorized = false
        if Config?.policeCanTreat?.enabled then
            if HasGroup(source, Config.policeCanTreat.jobs) then
                authorized = true
            end
        end
        if HasGroup(source, Config.ambulanceJob) or authorized then
            TriggerClientEvent('wasabi_ambulance:intoVehicle', target)
        end
    end
end)

RegisterServerEvent('wasabi_ambulance:restock')
AddEventHandler('wasabi_ambulance:restock', function(data)
    if HasGroup(source, Config.ambulanceJob) then
        if not data.price then
            AddItem(source, data.item, 1)
        else
            if GetPlayerAccountFunds(source, 'money') < data.price then
                TriggerClientEvent('wasabi_ambulance:notify', source, Strings.not_enough_funds, Strings.not_enough_funds_desc, 'error')
            else
                RemoveMoney(source, 'money', data.price)
                AddItem(source, data.item, 1)
            end
        end
    end
end)

lib.callback.register('wasabi_ambulance:checkDeath', function(source)
    if Framework == 'qb' then
        local player = GetPlayer(source)
        if not player then return end
        return player.PlayerData.metadata['isdead']
    else
        local isDead = ''
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(data)
            if data then
                isDead = data
            end
        end)
        while isDead == '' do Wait() end
        return isDead
    end
end)

if Framework == 'esx' then
    ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
        if deadPlayers[source] then
            cb(true)
        else
            cb(false)
        end
    end)
end

if Framework == 'esx' then
    ESX.RegisterServerCallback('wasabi_ambulance:tryRevive', function(source, cb, cost, max, account)
        local players = GetPlayers()
        local ems = 0
        for i=1, #players, 1 do
            if HasGroup(players[i], Config.ambulanceJob) then
                ems = ems + 1
            end
        end
        if max then
            if ems > max then
                cb('max')
            end
        end
        if cost then
            local funds = GetPlayerAccountFunds(source, account)
            if funds < cost then
                cb(false)
            else
                RemoveMoney(source, account, cost)
                TriggerClientEvent('wasabi_ambulance:revive', source)
                cb('success')
            end
        else
            TriggerClientEvent('wasabi_ambulance:revive', source)
            cb('success')
        end
    end)
end

lib.callback.register('wasabi_ambulance:tryRevive', function(source, cost, max, account)
    local players = GetPlayers()
    local ems = 0
    for i=1, #players, 1 do
        if HasGroup(players[i], Config.ambulanceJob) then
            ems = ems + 1
        end
    end
    if max then
        if ems > max then
            return 'max'
        end
    end
    if cost then
        local funds = GetPlayerAccountFunds(source, account)
        if funds < cost then
            return false
        else
            RemoveMoney(source, account, cost)
            TriggerClientEvent('wasabi_ambulance:revive', source)
            return 'success'
        end
    else
        TriggerClientEvent('wasabi_ambulance:revive', source)
        return 'success'
    end
end)

lib.callback.register('wasabi_ambulance:getDeathPos', function(source, targetId)
    local coords = GetEntityCoords(GetPlayerPed(targetId))
    return vector3(coords.x, coords.y, coords.z)
end)


lib.callback.register('wasabi_ambulance:isPlayerDead', function(source, target)
    if deadPlayers[target] then
        return true
    else
        return false
    end
end)

lib.callback.register('wasabi_ambulance:diagnosePatient', function(source, target)
    if Injury[target] then
        return (Injury[target])
    else
        return false
    end
end)

lib.callback.register('wasabi_ambulance:itemCheck', function(source, item)
    return HasItem(source, item)
end)

lib.callback.register('wasabi_ambulance:gItem', function(source, item)
    local authorized = false
    if Config?.policeCanTreat?.enabled then
        if HasGroup(source, Config.policeCanTreat.jobs) then
            authorized = true
        end
    end
    if HasGroup(source, Config.ambulanceJob) or authorized then
        AddItem(source, item, 1)
        return true
    else
        return false
    end
end)

lib.callback.register('wasabi_ambulance:canPurchase', function(source, data)
    local itemData
    if data.grade > #Config.Locations[data.id].MedicalWeapons.weapons then
        itemData = Config.Locations[data.id].MedicalWeapons.weapons[#Config.Locations[data.id].MedicalWeapons.weapons][data.itemId]
    elseif not Config.Locations[data.id].MedicalWeapons.weapons[data.grade] then
        print('[wasabi_police] : Armory not set up properly for job grade: '..data.grade)
    else
        itemData = Config.Locations[data.id].MedicalWeapons.weapons[data.grade][data.itemId]
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

RegisterServerEvent('wasabi_ambulance:billPlayer')
AddEventHandler('wasabi_ambulance:billPlayer', function(target, amount)
    local player = GetPlayer(target)
    if player then
        local identifier = GetIdentifier(source)
        exports.pefcl:createInvoice(source, { to = xPlayer.getName(), toIdentifier = identifier, from = 'Hospital', fromIdentifier = nil, amount = amount, message = 'Medical Bills', receiverAccountIdentifier = Config.ambulanceJob, expiresAt = nil })
    end
end)

RegisterServerEvent('wasabi_ambulance:qbBill')
AddEventHandler('wasabi_ambulance:qbBill', function(target, amount, job)
    RemoveMoney(target, 'bank', amount)
    TriggerClientEvent('wasabi_ambulance:notify', source, Strings.fine_sent, (Strings.fine_sent_desc):format(addCommas(amount)), 'success')
    TriggerClientEvent('wasabi_ambulance:notify', target, Strings.fine_received, (Strings.fine_received_desc):format(addCommas(amount)), 'error')
    exports['qb-management']:AddMoney(job, amount)
end)

RegisterServerEvent('wasabi_ambulance:svToggleDuty')
AddEventHandler('wasabi_ambulance:svToggleDuty', function(job, grade)
    ToggleDuty(source, job, grade)
end)

RegisterUsableItem(Config.EMSItems.medbag, function(source)
    RemoveItem(source, Config.EMSItems.medbag, 1)
    TriggerClientEvent('wasabi_ambulance:useMedbag', source)
end)

RegisterUsableItem(Config.EMSItems.revive.item, function(source)
    TriggerClientEvent('wasabi_ambulance:reviveTarget', source)
end)

RegisterUsableItem(Config.EMSItems.heal.item, function(source)
    TriggerClientEvent('wasabi_ambulance:healTarget', source)
end)

RegisterUsableItem(Config.EMSItems.sedate.item, function(source)
    TriggerClientEvent('wasabi_ambulance:useSedative', source)
end)

RegisterUsableItem(Config.EMSItems.stretcher, function(source)
    RemoveItem(source, Config.EMSItems.stretcher, 1)
    TriggerClientEvent('wasabi_ambulance:useStretcher', source)
end)

if Config.Bandages.enabled then
    RegisterUsableItem(Config.Bandages.item, function(source)
        TriggerClientEvent('wasabi_ambulance:useBandage', source)
    end)
end

CreateThread(function()
    for k,v in pairs(Config.TreatmentItems) do
        RegisterUsableItem(v, function(source)
            TriggerClientEvent('wasabi_ambulance:treatPatient', source, k)
        end)
    end
end)

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
    if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
        return
    end
    if eventData.id == -1 then
        for _, playerId in ipairs(GetPlayers()) do
            if deadPlayers[playerId] then
                TriggerClientEvent('wasabi_ambulance:revive', playerId)
            end
        end
    else
        if deadPlayers[eventData.id] then
            TriggerClientEvent('wasabi_ambulance:revive', eventData.id)
        end
    end
end)
