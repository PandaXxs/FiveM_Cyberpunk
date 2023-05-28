--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action)
    action:triggerListener(0)
    return true
end

Action.new()
      :setId("self_revive")
      :setLabel(Localization.actions_starterPack_self_revive)
      :setPermission("self.revive")
      :setRetention(ActionRetention.SELF)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 4)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()