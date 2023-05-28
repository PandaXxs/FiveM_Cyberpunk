---@param player Player
---@param action Action
handleActionListener("player_ban", 0, function(player, action, targetServerId, reason, duration)
    Functions.banPlayer(targetServerId, reason, duration)
end)