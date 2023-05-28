---@param player Player
---@param action Action
handleActionListener("player_give_vehicle", 0, function(player, action, model, targetServerId)
    local targetPlayer = PlayersManager:get(targetServerId)
    local vehicle = CreateVehicle(GetHashKey(model), GetEntityCoords(targetPlayer.ped), GetEntityHeading(targetPlayer.ped), true)
    TaskWarpPedIntoVehicle(targetPlayer.ped, vehicle, -1)
end)