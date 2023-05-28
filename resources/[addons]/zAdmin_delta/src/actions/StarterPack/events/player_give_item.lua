---@param player Player
---@param action Action
handleActionListener("player_give_item", 0, function(player, action, targetServerId, itemName, quantity)
    Functions.giveItem(targetServerId, itemName, quantity)
end)