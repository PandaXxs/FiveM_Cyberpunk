--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action, targetServerId)
    local reason = Utils:showKeyboard(Localization.generic_reason, "", 1000, false)
    if (reason ~= nil and reason ~= "") then
        action:triggerListener(0, targetServerId, reason)
        return true
    end
    return false
end

Action.new()
      :setId("player_kick")
      :setLabel(("~o~%s"):format(Localization.actions_starterPack_player_kick))
      :setPermission("player.kick")
      :setRetention(ActionRetention.PLAYER)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 6)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()