---@param player Player
---@param action Action
handleActionListener("self_heal", 0, function(player, action)
    Functions.healPlayer(player.serverId)
end)