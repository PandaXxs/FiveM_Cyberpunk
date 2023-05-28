if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports['es_extended']:getSharedObject()
Framework = 'esx'

RegisterServerEvent('projectrpUtils:pay')
AddEventHandler('projectrpUtils:pay', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if amount then
        if xPlayer.getMoney() >= amount then
            xPlayer.removeMoney(amount)
            TriggerClientEvent('projectrpUtils:notify', src, 'Paiement effectué', 'Vous avez payé ' .. amount .. '$', 'success')
        else
            TriggerClientEvent('projectrpUtils:notify', src, 'Paiement refusé', 'Vous n\'avez pas assez d\'argent', 'error')
            return
        end
    end

end)

RegisterServerEvent('projectrpUtils:giveItem')
AddEventHandler('projectrpUtils:giveItem', function(item, label, amount, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if item then
        if xPlayer.getMoney() >= price then
            xPlayer.addInventoryItem(item, amount)
            TriggerClientEvent('projectrpUtils:notify', src, 'Objet reçu', 'Vous avez reçu '.. amount ..' '.. label, 'success')
        end
    end
end)

RegisterServerEvent('projectrpUtils:spawnVehicle')
AddEventHandler('projectrpUtils:spawnVehicle', function(model, spawnLoc, spawnHeading, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getMoney() >= price then
        -- On spawn le véhicle coté serveur 
        local vehicle = CreateVehicle(GetHashKey(model), spawnLoc.x, spawnLoc.y, spawnLoc.z, spawnHeading, true, false)
        -- Plaque du véhicule
        local plate = 'LOC' .. math.random(100, 900)
        SetVehicleNumberPlateText(vehicle, plate)
        -- On warp le joueur dans le véhicule
        TaskWarpPedIntoVehicle(source, vehicle, -1)
        -- On donne les clés au joueur
        exports.wasabi_carlock:GiveKeys(plate, source)
    end

end)

RegisterServerEvent('projectrpUtils:sendAnnounce')
AddEventHandler('projectrpUtils:sendAnnounce', function(title, desc, position, styleBG, styleColor, icon, iconColor, duration, playerId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    TriggerClientEvent('projectrpUtils:customNotify', playerId, title, desc, position, styleBG, styleColor, icon, iconColor, duration)
end)

function GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function HasGroup(source, filter)
    local player = GetPlayer(source)
    local type = type(filter)

    if type == 'string' then
        if player.job.name == filter then
            return player.job.name, player.job.grade
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            local grade = filter[player.job.name]

            if grade and grade <= player.job.grade then
                return player.job.name, player.job.grade
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                if player.job.name == filter[i] then
                    return player.job.name, player.job.grade
                end
            end
        end
    end
end