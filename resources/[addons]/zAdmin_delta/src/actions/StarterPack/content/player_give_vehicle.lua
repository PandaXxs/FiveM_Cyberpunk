--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action, targetServerId)
    local model = Utils:showKeyboard(Localization.generic_model, "", 20, false)
    if (model ~= nil and model ~= "" and IsModelValid(GetHashKey(model))) then
        action:triggerListener(0, model, targetServerId)
        return true
    end
    return false
end

Action.new()
      :setId("player_give_vehicle")
      :setLabel(Localization.actions_starterPack_player_give_vehicle)
      :setPermission("player.givevehicle")
      :setRetention(ActionRetention.PLAYER)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 5)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()
