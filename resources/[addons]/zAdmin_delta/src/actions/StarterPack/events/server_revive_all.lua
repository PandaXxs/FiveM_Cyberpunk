---@param player Player
---@param action Action
handleActionListener("server_revive_all", 0, function(player, action)
    for _, player in ipairs(PlayersManager.list) do
        Functions.revivePlayer(player.serverId)
    end
end)