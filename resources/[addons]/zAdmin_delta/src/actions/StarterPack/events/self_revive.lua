---@param player Player
---@param action Action
handleActionListener("self_revive", 0, function(player, action)
    Functions.revivePlayer(player.serverId)
end)