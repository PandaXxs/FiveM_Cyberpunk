--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action, targetServerId)
    local itemName = Utils:showKeyboard(Localization.generic_item_name, "", 20, false)
    if (not itemName or itemName == "") then
        return false
    end
    local itemCount = tonumber(Utils:showKeyboard(Localization.generic_quantity, "", 20, false))
    if (not itemCount) then
        return false
    end
    action:triggerListener(0, targetServerId, itemName, itemCount)
    return true
end

Action.new()
      :setId("player_give_item")
      :setLabel(Localization.actions_starterPack_player_items)
      :setPermission("player.items")
      :setRetention(ActionRetention.PLAYER)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 5)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()
