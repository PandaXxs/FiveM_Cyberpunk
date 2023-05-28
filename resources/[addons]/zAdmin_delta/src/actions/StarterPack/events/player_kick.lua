---@param player Player
---@param action Action
handleActionListener("player_kick", 0, function(player, action, targetServerId, reason)
    Functions.kickPlayer(targetServerId, reason)
end)