

RegisterServerEvent("projectrpUtils:AlReadyHoldUP")
AddEventHandler("projectrpUtils:AlReadyHoldUP", function(HoldUP)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem("drill", 1)
    TriggerClientEvent("projectrpUtils:AlReadyHoldUP", -1, HoldUP)
end)

RegisterServerEvent("projectrpUtils:OpenDoorHoldUP")
AddEventHandler("projectrpUtils:OpenDoorHoldUP", function(UpdateHoldUP)
    TriggerClientEvent("projectrpUtils:OpenDoorHoldUP", -1, UpdateHoldUP)
end)

RegisterServerEvent("projectrpUtils:HoldUPGiveMoney")
AddEventHandler("projectrpUtils:HoldUPGiveMoney", function(money)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney("money", money)
end)

RegisterServerEvent("projectrpUtils:HoldUPSendAlerte")
AddEventHandler("projectrpUtils:HoldUPSendAlerte", function(coords)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local thexPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thexPlayer.job.name == "police" then
            TriggerClientEvent("projectrpUtils:HoldUPSendAlerte", xPlayers[i], coords)
        end
    end
end)