--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action)
    ActionsInternal.tpWaypoint()
end

Action.new()
      :setId("self_tp_waypoint")
      :setLabel(Localization.actions_starterPack_self_tp_waypoint)
      :setPermission("self.teleport")
      :setRetention(ActionRetention.SELF)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 5)
      :setHandlerTable(onAction)
      :build()