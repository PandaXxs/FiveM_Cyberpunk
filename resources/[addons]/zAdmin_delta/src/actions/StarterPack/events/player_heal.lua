---@param player Player
---@param action Action
handleActionListener("player_heal", 0, function(player, action, targetServerId)
    Functions.healPlayer(targetServerId)
end)