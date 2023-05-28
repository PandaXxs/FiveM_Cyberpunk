---@param player Player
---@param action Action
handleActionListener("player_revive", 0, function(player, action, targetServerId)
    Functions.revivePlayer(targetServerId)
end)