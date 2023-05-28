---@param player Player
---@param action Action
handleActionListener("vehicle_clear_zone", 0, function(player, action, vehicles)
    for _, vehicle in pairs(vehicles) do
        vehicle = NetworkGetEntityFromNetworkId(vehicle)
        DeleteEntity(vehicle)
    end
end)