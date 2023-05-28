ESX = exports['es_extended']:getSharedObject()

-- OR IF USE ES_EXTENDED later version

-- ESX = nil
-- TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

ESX.RegisterServerCallback("projectrpUtils:CheckJobOnline", function(source, cb, job)
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == job then
            cops = cops + 1
        end
    end
    cb(cops)
end)

ESX.RegisterServerCallback("projectrpUtils:GetItemInventoryCount", function(source, callback, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    callback(xPlayer.getInventoryItem(item).count)
end)
