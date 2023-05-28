local inService = {
    ["ambulance"] = {},
    ["offpolice"] = {},
    ["police"] = {},
}

local inHistorique = {
    ["ambulance"] = {},
    ["offpolice"] = {},
    ["police"] = {},
}

function removeService(src, job)
    for k, v in pairs(inService[job]) do
        if v == src then
            table.remove(inService[job], k)
            break
        end
    end
end

function GetCountJobInService(job)
    local count = 0 

    for k, v in pairs(inService[job]) do
        count = count + 1
    end
    return count
end

RegisterNetEvent("player:serviceOn")
AddEventHandler("player:serviceOn", function(job)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    -- print("xPlayer: "..xPlayer.job.name .. " - Job: " .. job)

    if xPlayer.job.name == job or xPlayer.job.name == 'offpolice' then
        -- print("insertService ".. job)
        table.insert(inService[job], _src)
    end
end)

RegisterNetEvent("player:serviceOff")
AddEventHandler("player:serviceOff", function(job)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    -- print("xPlayer: "..xPlayer.job.name .. " - Job: " .. job)

    if xPlayer.job.name == job or xPlayer.job.name == 'offpolice' then
        -- print("removeService ".. job)
        removeService(_src, job)
    end
end)

RegisterNetEvent("call:makeCallSpecial")
AddEventHandler("call:makeCallSpecial", function(job, pos, message, target, icon)
    -- print("call:makeCallSpecial")
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    for _, player in pairs(inService[job]) do
        TriggerClientEvent("call:callIncoming", player, job, pos, message, target, icon)
    end
end)

ESX.RegisterServerCallback('HistoriqueCall', function(source, cb, job)
    cb(inHistorique[job])
end)

RegisterNetEvent("call:AccepteCall")
AddEventHandler("call:AccepteCall", function(job)
    local xPlayer = ESX.GetPlayerFromId(source)

    for _, player in pairs(inService[job]) do
        TriggerClientEvent("esx:showNotification", player, "L'appel a été pris par ~g~"..xPlayer.getName())
    end
end)

AddEventHandler("playerDropped", function(reason)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if xPlayer then
        removeService(_src, xPlayer.job.name)
    end
end)

ESX.RegisterServerCallback('JobInService', function(source, cb, job)
    local count = 0 

    for k, v in pairs(inService[job]) do
        count = count + 1
    end
    cb(count)
end)