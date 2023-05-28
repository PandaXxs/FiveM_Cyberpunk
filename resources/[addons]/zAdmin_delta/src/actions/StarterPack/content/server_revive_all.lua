--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action)
    action:triggerListener(0)
    return true
end

Action.new()
      :setId("server_revive_all")
      :setLabel(Localization.actions_starterPack_server_revive_all)
      :setPermission("server.reviveAll")
      :setRetention(ActionRetention.SERVER)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 2)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()