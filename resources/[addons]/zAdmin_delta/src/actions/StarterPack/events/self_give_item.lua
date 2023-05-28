---@param player Player
---@param action Action
handleActionListener("self_give_item", 0, function(player, action, itemName, quantity)
    Functions.giveItem(player.serverId, itemName, quantity)
end)