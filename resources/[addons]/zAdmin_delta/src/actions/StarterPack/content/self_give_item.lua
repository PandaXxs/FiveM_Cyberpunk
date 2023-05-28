--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action)
    local itemName = Utils:showKeyboard(Localization.generic_item_name, "", 20, false)
    if (not itemName or itemName == "") then
        return false
    end
    local itemCount = tonumber(Utils:showKeyboard(Localization.generic_quantity, "", 20, false))
    if (not itemCount) then
        return false
    end
    action:triggerListener(0, itemName, itemCount)
    return true
end

Action.new()
      :setId("self_give_item")
      :setLabel(Localization.actions_starterPack_self_items)
      :setPermission("self.items")
      :setRetention(ActionRetention.SELF)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 5)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()
