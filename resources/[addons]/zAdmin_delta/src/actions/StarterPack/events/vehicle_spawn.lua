---@param player Player
---@param action Action
handleActionListener("vehicle_spawn", 0, function(player, action, model)
    local vehicle = CreateVehicle(GetHashKey(model), GetEntityCoords(player.ped), GetEntityHeading(player.ped), true)
    TaskWarpPedIntoVehicle(player.ped, vehicle, -1)
end)