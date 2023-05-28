--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action)
    local vehicles = ActionsInternal.getVehiclesInRange()
    if (not vehicles) then
        return false
    end
    action:triggerListener(0, vehicles)
    return true
end

Action.new()
      :setId("vehicle_clear_zone")
      :setLabel(Localization.actions_starterPack_vehicle_clear_zone)
      :setPermission("vehicles.clear")
      :setRetention(ActionRetention.VEHICLE)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 3)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()
