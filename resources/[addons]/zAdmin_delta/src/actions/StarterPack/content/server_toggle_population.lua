--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action)
    action:triggerListener(0)
    return true
end

Action.new()
      :setId("server_toggle_population")
      :setLabel(Localization.actions_starterPack_server_toggle_population)
      :setPermission("server.population")
      :setRetention(ActionRetention.SERVER)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 1)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()