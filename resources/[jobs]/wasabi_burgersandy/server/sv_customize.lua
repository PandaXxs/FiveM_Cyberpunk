-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
QS = nil
if Config.Inventory == 'qs' then
    TriggerEvent('qs-core:getSharedObject', function(library) QS = library end)
end

RegisterNetEvent('wasabi_burgersandy:punishPlayer', function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.kick(string.format('You got kicked!\n\nAuthor: %s\nReason: %s\n\nYou think this punishment was not fair?\nContact our support at discord.gg/', GetCurrentResourceName(), reason))

    --[[
        EASYADMIN EXAMPLE
        TriggerEvent('EasyAdmin:addBan', source, reason, 31556926, GetCurrentResourceName())
    --]]
end)
