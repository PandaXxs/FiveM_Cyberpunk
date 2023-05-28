local spawnedPeds, netIdTable = {}, {}

-- get keys utils
local function get_key(t)
    local key
    for k, _ in pairs(t) do
        key = k
    end
    return key
end

-- Resource starting
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    if Config.EnablePeds then BANK.CreatePeds() end
    local twoMonthMs = (os.time() - 5259487) * 1000
    MySQL.Sync.fetchScalar('DELETE FROM crypto WHERE time < ? ', {twoMonthMs})
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    if Config.EnablePeds then BANK.DeletePeds() end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if not Config.EnablePeds then return end
	TriggerClientEvent('esx_crypto:PedHandler', playerId, netIdTable)
end)

-- event
RegisterServerEvent('esx_crypto:doingType')
AddEventHandler('esx_crypto:doingType', function(typeData)
    if source == nil then return end
    if (typeData == nil) then return end

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local money = xPlayer.getAccount('money').money
    local crypto = xPlayer.getAccount('crypto').money
    local amount

    local key = get_key(typeData)
    if typeData.withdraw then
        amount = tonumber(typeData.withdraw)
    elseif typeData.transfer and typeData.transfer.moneyAmount then
        amount = tonumber(typeData.transfer.moneyAmount)
    end

    if not tonumber(amount) then return end
    amount = ESX.Math.Round(amount)

    if amount == nil or (amount <= 0) then
        TriggerClientEvent("esx:showNotification", source, TranslateCap('invalid_amount'), "error")
    else
        if typeData.withdraw and crypto ~= nil and amount <= crypto then
            -- withdraw
            BANK.Withdraw(amount, xPlayer)
            -- Notif 
            TriggerClientEvent("esx:showNotification", source, TranslateCap('withdraw_money', amount), "success")
        elseif typeData.transfer then
            -- transfer
            if tonumber(typeData.transfer.playerId) > 0 and crypto >= amount then
                local xTarget = ESX.GetPlayerFromId(tonumber(typeData.transfer.playerId))
                if not BANK.Transfer(xTarget, xPlayer, amount, key) then
                    return
                end
            end
        else
            TriggerClientEvent("esx:showNotification", source, TranslateCap('not_enough_money', amount), "error")
            return
        end

        money = xPlayer.getAccount('money').money
        crypto = xPlayer.getAccount('crypto').money
        if typeData.transfer then
            TriggerClientEvent("esx:showNotification", source,
                TranslateCap(string.format('%s_money', key), amount, typeData.transfer.playerId), "success")
        end

        TriggerClientEvent("esx_crypto:updateMoneyInUI", source, key, crypto, money)
    end
end)

-- register callbacks
ESX.RegisterServerCallback("esx_crypto:getPlayerData", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local weekAgo = (os.time() - 604800) * 1000
    local transactionHistory = MySQL.Sync.fetchAll(
        'SELECT * FROM crypto WHERE identifier = ? AND time > ? ORDER BY time DESC LIMIT 10', {identifier, weekAgo})
    local playerData = {
        playerName = xPlayer.getName(),
        money = xPlayer.getAccount('money').money,
        crypto = xPlayer.getAccount('crypto').money,
        transactionHistory = transactionHistory
    }

    cb(playerData)
end)

function logTransaction(targetSource,key,amount)
    if targetSource == nil then
        print("ERROR: TargetSource nil!")
        return
    end

    if key == nil then
        print("ERROR: Do you need use these: WITHDRAW,TRANSFER_RECEIVE")
        return
    end
    
    if type(key) ~= "string" or key == '' then
        print("ERROR: Do you need use these: WITHDRAW,TRANSFER_RECEIVE and can only be string type!")
        return
    end

    if amount == nil then
        print("ERROR: Amount value is nil! Add some numeric value to the amount!")
        return
    end

    local xPlayer = ESX.GetPlayerFromId(tonumber(targetSource))

    if xPlayer ~= nil then
        local cryptoCurrentMoney = xPlayer.getAccount('crypto').money
        BANK.LogTransaction(targetSource, string.upper(key), amount, cryptoCurrentMoney)  
    else
        print("ERROR: xPlayer is nil!") 
    end
end
exports("logTransaction", logTransaction)

-- crypto functions
BANK = {
    CreatePeds = function()
        for i = 1, #Config.Peds do
            local model = Config.Peds[i].Model
            local coords = Config.Peds[i].Position
            spawnedPeds[i] = CreatePed(0, model, coords.x, coords.y, coords.z, coords.w, true, true)
            netIdTable[i] = NetworkGetNetworkIdFromEntity(spawnedPeds[i])
            while not DoesEntityExist(spawnedPeds[i]) do Wait(50) end
        end

        Wait(100)
        TriggerClientEvent('esx_crypto:PedHandler', -1, netIdTable)
    end,
    DeletePeds = function()
        for i = 1, #spawnedPeds do
            DeleteEntity(spawnedPeds[i])
            spawnedPeds[i] = nil
        end
    end,
    Withdraw = function(amount, xPlayer)
        xPlayer.addAccountMoney('money', amount * 2)
        xPlayer.removeAccountMoney('crypto', amount)
    end,
    Transfer = function(xTarget, xPlayer, amount, key)
        if xTarget == nil or xPlayer.source == xTarget.source then
            TriggerClientEvent("esx:showNotification", source, TranslateCap("cant_do_it"), "error")
            return false
        end

        xPlayer.removeAccountMoney('crypto', amount)
        xTarget.addAccountMoney('crypto', amount)
        local crypto = xTarget.getAccount('crypto').money
        BANK.LogTransaction(xTarget.source, "TRANSFER_RECEIVE", amount, crypto)
        TriggerClientEvent("esx:showNotification", xTarget.source, TranslateCap('receive_transfer', amount, xPlayer.source),
            "success")

        return true
    end,
    LogTransaction = function(playerId, logType, amount, crypto)
        if playerId == nil then
            return
        end
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local identifier = xPlayer.getIdentifier()

        MySQL.insert('INSERT INTO crypto (identifier, type, amount, time, balance) VALUES (?, ?, ?, ?, ?)',
            {identifier, logType, amount, os.time() * 1000, crypto})
    end   
}


-- commande de give de crypto
RegisterCommand('givecrypto', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))
    local amount = tonumber(args[2])
    if xPlayer.getGroup() == 'admin' then
        if xTarget ~= nil then
            xTarget.addAccountMoney('crypto', amount)
            TriggerClientEvent("esx:showNotification", xTarget.source, TranslateCap('receive_transfer', amount, xPlayer.source),
            "success")
        else
            TriggerClientEvent("esx:showNotification", source, TranslateCap("cant_do_it"), "error")
        end
    end
end, false)