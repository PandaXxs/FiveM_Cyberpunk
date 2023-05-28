--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action, targetServerId)
    action:triggerListener(0, targetServerId)
    return true
end

Action.new()
      :setId("player_revive")
      :setLabel(Localization.actions_starterPack_player_revive)
      :setPermission("player.revive")
      :setRetention(ActionRetention.PLAYER)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 3)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()